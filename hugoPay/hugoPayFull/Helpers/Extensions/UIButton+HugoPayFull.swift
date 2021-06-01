//
//  UIButton+HugoPayFull.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 16/4/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// Sets the color of the background to use for the specified state.
    ///
    /// In general, if a property is not specified for a state, the default is to use the [normal](apple-reference-documentation://hsOohbJNGp) value.
    /// If the normal value is not set, then the property defaults to a system value.
    /// Therefore, at a minimum, you should set the value for the normal state.
    /// - Author: [Dongkyu Kim](https://gist.github.com/stleamist)
    /// - Parameters:
    ///     - color: The color of the background to use for the specified state
    ///     - cornerRadius: The radius, in points, for the rounded corners on the button. The default value is 8.0.
    ///     - state: The state that uses the specified color. The possible values are described in [UIControl.State](apple-reference-documentation://hs-yI2haNm).
    ///
    func setBackgroundColor(_ color: UIColor?, cornerRadius: CGFloat = 8.0, for state: UIControl.State) {
        
        guard let color = color else {
            self.setBackgroundImage(nil, for: state)
            return
        }
        
        let length = 1 + cornerRadius * 2
        let size = CGSize(width: length, height: length)
        let rect = CGRect(origin: .zero, size: size)
        
        var backgroundImage = UIGraphicsImageRenderer(size: size).image { (context) in
            // Fill the square with the black color for later tinting.
            color.setFill()
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).fill()
        }
        
        backgroundImage = backgroundImage.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
        
        // Apply the `color` to the `backgroundImage` as a tint color
        // so that the `backgroundImage` can update its color automatically when the currently active traits are changed.
        if #available(iOS 13.0, *) {
            backgroundImage = backgroundImage.withTintColor(color, renderingMode: .alwaysOriginal)
        }
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
    
    func makeHugoButton(title : String){
//        if isYummy(){
//            self.backgroundColor = R.color.yummyGreenLite()
//        }else{
//            self.backgroundColor = UIColor.init(hex: Colors.hugoButtonNew.rawValue)
//        }
        self.backgroundColor = UIColor.init(hex: Colors.hugoButtonNew.rawValue)
        self.setBackgroundColor(UIColor(hex: Colors.hugoButtonNew.rawValue), cornerRadius: self.frame.size.height/2, for: .selected)
        self.layer.cornerRadius = self.frame.size.height/2
        self.setTitleColor(.white, for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: Fonts.Bold.rawValue, size: 11.0)
        let title = self.title(for: .normal)
        let attributedTitle = NSAttributedString(string: title ?? "", attributes: [NSAttributedString.Key.kern: 2.0])
        self.setAttributedTitle(attributedTitle, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: self.frame.size.height * 0.1, left: self.frame.size.width * 0.1, bottom: self.frame.size.height * 0.1, right: self.frame.size.width * 0.1)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func makeHugoPayFullButton(title : String){
        self.backgroundColor = UIColor.init(hex: Colors.hugoPayPurple.rawValue)
        self.setBackgroundColor(UIColor(hex: Colors.hugoButtonNew.rawValue), cornerRadius: self.frame.size.height/2, for: .selected)
        self.layer.cornerRadius = self.frame.size.height/2
        self.setTitleColor(.white, for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: Fonts.Bold.rawValue, size: 11.0)
        let title = self.title(for: .normal)
        let attributedTitle = NSAttributedString(string: title ?? "", attributes: [NSAttributedString.Key.kern: 2.0])
        self.setAttributedTitle(attributedTitle, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: self.frame.size.height * 0.1, left: self.frame.size.width * 0.1, bottom: self.frame.size.height * 0.1, right: self.frame.size.width * 0.1)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func makeHugoClearButtonWithoutBorder(title : String){
        self.backgroundColor = .none
        self.setBackgroundColor(.clear, cornerRadius: self.frame.size.height/2, for: .selected)
        self.layer.cornerRadius = self.frame.size.height/2
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.init(hex: Colors.hugoLight.rawValue), for: .normal)
        self.titleLabel?.font = UIFont(name: Fonts.Bold.rawValue, size: 12.0)
        let title = self.title(for: .normal)
        let attributedTitle = NSAttributedString(string: title ?? "", attributes: [NSAttributedString.Key.kern: 1.0])
        self.setAttributedTitle(attributedTitle, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: self.frame.size.height * 0.1, left: self.frame.size.width * 0.1, bottom: self.frame.size.height * 0.1, right: self.frame.size.width * 0.1)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}
