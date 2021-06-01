//
//  UIView+extension.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/27/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

public enum LinePosition {
    case top
    case bottom
}

public extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: self, options: nil)![0] as! T
    }
    
    func round(with radius: CGFloat, corners: UIRectCorner) {
    let roundedPath = UIBezierPath(roundedRect: bounds,
    byRoundingCorners: corners,
    cornerRadii: CGSize(width: radius, height: radius))
    let maskLayer = CAShapeLayer()
            maskLayer.path = roundedPath.cgPath
            layer.mask = maskLayer
        }
    
    func makeCorner(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.isOpaque = false
    }
    
    func addLine(position: LinePosition, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false 
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))

        switch position {
        case .top:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .bottom:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}
