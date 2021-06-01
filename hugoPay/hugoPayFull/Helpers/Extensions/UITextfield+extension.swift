//
//  UITextfield+extension.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/26/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
