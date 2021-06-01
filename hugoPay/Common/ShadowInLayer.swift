//
//  ShadowInLayer.swift
//  Hugo
//
//  Created by Developer on 3/22/19.
//  Copyright © 2019 Clever Mobile Apps. All rights reserved.
//

import UIKit

extension CALayer {
    
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == "shadowLayer" {
                
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = "shadowLayer"
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
    
    func addShadow() {
        self.shadowOffset = CGSize(width: 1, height: 1)
        self.shadowOpacity = 0.05
        self.shadowRadius = 5.0
        self.shadowColor = UIColor(hex: Colors.hugoShadow.rawValue).cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }

    func addShadowRide() {
        self.shadowOffset = CGSize(width: 1, height: 4)
        self.shadowOpacity = 0.15
        self.shadowRadius = 4.0
        self.shadowColor = UIColor.init(hexString: "27347D")?.cgColor
        self.masksToBounds = false

        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }

    func addShadowTopView() {
        self.shadowOffset = CGSize(width: 0, height: 2)
        self.shadowOpacity = 0.09
        self.shadowRadius = 8.0
        self.shadowColor = UIColor.init(hexString: "3b424b")?.cgColor
        self.masksToBounds = false

        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func addShadowElements() {
        self.shadowOffset = CGSize(width: 0, height: 2)
        self.shadowOpacity = 0.09
        self.shadowRadius = 4.0
        self.shadowColor = UIColor.init(hexString: "3b424b")?.cgColor
        self.masksToBounds = false

        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func addShadowHistoryLogo() {
        self.shadowOffset = CGSize(width: 0, height: 6)
        self.shadowOpacity = 0.11
        self.shadowRadius = 7.0
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false

        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func addShadowBottomView() {
        self.shadowOffset = CGSize(width: 1, height: 4)
        self.shadowOpacity = 0.15
        self.shadowRadius = 4.0
        self.shadowColor = UIColor.init(hexString: "27347D")?.cgColor
        self.masksToBounds = false

        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func addShadowPayService() {
        self.shadowOffset = CGSize(width: 0, height: 5)
        self.shadowOpacity = 0.08
        self.shadowRadius = 8.0
        self.shadowColor = UIColor.init(hexString: "3b424b")?.cgColor
        self.masksToBounds = false

        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    
    
    func addBlackShadow() {
        self.shadowOffset = CGSize(width: 1, height: 1)
        self.shadowOpacity = 0.1
        self.shadowRadius = 5.0
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func applySketchShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        self.masksToBounds = false
    }
    
}

