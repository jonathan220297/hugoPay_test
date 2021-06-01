//
//  String+HugoPayFull.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 25/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

extension String {
    //Localizable
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(_ arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
    // formatting text for currency textField
    func currencyInputFormatting(with currency: String) -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex
            .stringByReplacingMatches(in: amountWithPrefix,
                                      options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                      range: NSMakeRange(0, self.count),
                                      withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func removeFormatAmount() -> Double {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.currencySymbol = UserManager.shared.symbol ?? "$"
        
        return formatter.number(from: self) as! Double? ?? 0
    }
    
    
    func withBoldText(text: String, font: UIFont? = nil, fontColorBold: UIColor) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let fullString = NSMutableAttributedString(string: self, attributes: [.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            .font: R.font.gothamHTFBold(size: _font.pointSize) ?? UIFont.boldSystemFont(ofSize: _font.pointSize),
            .foregroundColor: fontColorBold
        ]
        let range = (self as NSString).range(of: text)
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }
}

