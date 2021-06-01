//
//  UIView+HugoPayFull.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 30/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBottomRoundedEdge() {
        let offset: CGFloat = (self.frame.width * 0.15)
        let bounds: CGRect = self.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width , height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset , height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        self.layer.mask = maskLayer
    }
}
