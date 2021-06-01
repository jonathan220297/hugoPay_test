//
//  NSAttributedString+HugoPay.swift
//  Hugo
//
//  Created by Carlos Landaverde on 11/30/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import UIKit

extension NSAttributedString {
    static func title(
        _ text: String,
        font: UIFont,
        color: UIColor,
        kern: CGFloat = 1.38
    ) -> NSMutableAttributedString {

        let attributesForName: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.kern: kern
        ]

        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: attributesForName
        )

        return attributedString
    }
}

extension NSMutableAttributedString {
    func bold(_ text: String, font: UIFont) {
        let range: NSRange = mutableString.range(
            of: text,
            options: .caseInsensitive
        )

        addAttribute(
            NSAttributedString.Key.font,
            value: font,
            range: range
        )
    }

    func setLineHeight(_ height: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = height
        paragraphStyle.alignment = .center

        addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: mutableString.length)
        )
    }
}
