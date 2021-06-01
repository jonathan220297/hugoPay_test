//
//  String+Extension.swift
//  Hugo
//
//  Created by Developer on 1311//18.
//  Copyright © 2018 Clever Mobile Apps. All rights reserved.
//

import UIKit

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func leftPadding(toLength: Int, withPad: String = " ") -> String {
        guard toLength > self.count else { return self }
        
        let padding = String(repeating: withPad, count: toLength - self.count)
        return padding + self
    }
    
    var hex: Int? {
        return Int(self, radix: 16)
    }
    
    func toDouble() -> Double {
        let nsString = self as NSString
        return nsString.doubleValue
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: CompareOptions.literal, range: nil)
    }
    
    func split(separator: String) -> [String] {
        return self.components(separatedBy: separator)
    }
    
    var pairs: [String] {
        var result: [String] = []
        let characters = Array(self)
        stride(from: 0, to: characters.count, by: 2).forEach {
            result.append(String(characters[$0..<min($0+2, characters.count)]))
        }
        return result
    }
    
    mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }
    
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: characters.count, by: n).forEach {
            result += String(characters[$0..<min($0+n, characters.count)])
            if $0+n < characters.count {
                result += separator
            }
        }
        return result
    }
    
    func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
    
    func isAlphanumeric(ignoreDiacritics: Bool = false) -> Bool {
        if ignoreDiacritics {
            return self.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil && self != ""
        }
        else {
            return self.isAlphanumeric()
        }
    }
    
    var removeDiacritic: String {
        return folding(options: .diacriticInsensitive, locale: .current)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        let htmlCSSString = """
        <style>
        html *
        {
        font-size: \(11)pt !important;
        color: #4D4D4D !important;
        font-family: \(Fonts.Book.rawValue) !important;
        }
        </style>
        </br>
        \(self)
        """
        
        do {
            guard let htmlString = htmlCSSString.data(using: String.Encoding.utf8) else { return nil }
            return try NSAttributedString(data: htmlString, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:\(error)" )
            return nil
        }
    }
    
    var htmlPayment: NSAttributedString? {
        let htmlCSSString = """
        <style>
        html *
        {
        text-align: justify;
        font-size: \(13)px !important;
        color: #80788C !important;
        font-family: \(Fonts.Book.rawValue) !important;
        }
        </style>
        </br>
        \(self)
        """
        
        do {
            guard let htmlString = htmlCSSString.data(using: String.Encoding.utf8) else { return nil }
            return try NSAttributedString(data: htmlString, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:\(error)" )
            return nil
        }
    }
    
    var htmlOrderReceived: NSAttributedString? {
        let htmlCSSString = """
        <style>
        html *
        {
        text-align: center;
        font-size: \(13)px !important;
        color: #FFFFFF !important;
        font-family: \(Fonts.Book.rawValue) !important;
        }
        </style>
        </br>
        \(self)
        """
        
        do {
            guard let htmlString = htmlCSSString.data(using: String.Encoding.utf8) else { return nil }
            return try NSAttributedString(data: htmlString, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:\(error)" )
            return nil
        }
    }
    
    func isHTML() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "<[^>]+>")
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.count > 0
        } catch {
            return false
        }
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func formatCurrency(symbol: String) -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = symbol
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9.]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: double)
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return formatter.string(from: number)!
        }
        
        return formatter.string(from: number)!
    }
    
    func currencyValue() -> Double {
        var amountWithPrefix = self
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9.]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        return double
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


extension StringProtocol {
    func ranges(of targetString: Self, options: String.CompareOptions = [], locale: Locale? = nil) -> [Range<String.Index>] {

        let result: [Range<String.Index>] = self.indices.compactMap { startIndex in
            let targetStringEndIndex = index(startIndex, offsetBy: targetString.count, limitedBy: endIndex) ?? endIndex
            return range(of: targetString, options: options, range: startIndex..<targetStringEndIndex, locale: locale)
        }
        return result
    }
}
