//
//  PullUpView.swift
//  PullUpView
//
//  Created by Juan Jose Maceda on 2/14/19.
//  Copyright © 2019 Hugo Technologies. All rights reserved.
//

import UIKit

protocol PullUpDelegate {
    func gesturePanEnded(endY: CGFloat)
}

class PullUpView: UIView {

    private var snaps: [CGPoint]?
    private var sortedSnaps: [CGPoint]?
    private var lastY: CGFloat!
    private var gestureRecognizer: UIPanGestureRecognizer!
    private var extraForDamping = CGFloat(0.0)
    private var actualHeight = CGFloat(0.0)

    private lazy var handler: UIView = {
        let handler = UIView()
        handler.backgroundColor = UIColor.lightGray
        handler.frame = CGRect(x: 0, y: 0, width: 60.0, height: 6.0)
        handler.layer.cornerRadius = 3
        handler.isUserInteractionEnabled = false
       // handler.backgroundColor = UIColor(red: 0.847, green: 0.816, blue: 0.894, alpha: 1)
        
        return handler
    }()
    
    private lazy var bottonView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var originalCenter: CGPoint!
    private var minY = CGFloat(0.0)
    private var limitPullup = CGFloat(0.0)
    
    private var maxY = CGFloat(0.0)
    private var limitPulldown = CGFloat(0.0)
    var insets = UIEdgeInsets.zero
    
    var delegate: PullUpDelegate?

    private var shadowLayer: CAShapeLayer!
    private var cornerRadiusFix: CGFloat = 14.0
    private var fillColor: UIColor = .clear

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 7
        self.backgroundColor = .clear
        self.gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.gestureRecognizer.cancelsTouchesInView = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer != nil {
            shadowLayer.removeFromSuperlayer();
        }

        //if shadowLayer == nil {
        shadowLayer = CAShapeLayer()

        shadowLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadiusFix, height: cornerRadiusFix)).cgPath
        shadowLayer.fillColor = fillColor.cgColor

        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: -1.0)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 3


        layer.insertSublayer(shadowLayer, at: 0)
        //}
    }

    private func positionHandler() {
        if self.handler.superview != nil { return }
        
        self.addSubview(self.handler)
        self.insets = UIEdgeInsets(top: 18.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.handler.center = self.center
        self.handler.frame.origin.y = 10.0
    }
    
    func setup(with snaps: [CGFloat], initCollapsed: Bool) {
        self.addGestureRecognizer(self.gestureRecognizer)
        
        if let superview = self.superview {
            superview.bringSubviewToFront(self)
            self.snaps = self.convertSnaps(snaps: snaps, height: superview.frame.height)
            self.sortedSnaps = self.snaps!.sorted { $0.y > $1.y }
            
            let maxPoint = self.sortedSnaps!.last!
            let minPoint = self.sortedSnaps!.first!
            
            //init open
            //print(superview.safeAreaInsets)
            let openHeight = initCollapsed ? minPoint.y : maxPoint.y
            let maxHeight = superview.frame.height-maxPoint.y
            self.frame = CGRect(x: 0, y: openHeight, width: superview.frame.width, height: maxHeight + self.extraForDamping)
            
            self.lastY = openHeight
            self.isHidden = false
            
            self.limitPullup = (maxHeight/2) + maxPoint.y
            self.limitPulldown = (maxHeight/2) + minPoint.y
            
            self.positionHandler()
            self.finishSetup()
        }
    }
    
    func setup(with fixedHeight: CGFloat) {
        guard let superview = self.superview else {
            return
        }
        
        self.removeGestureRecognizer(self.gestureRecognizer)
        
        superview.bringSubviewToFront(self)
        
        if self.handler.superview != nil {
            self.insets = UIEdgeInsets.zero
            self.handler.removeFromSuperview()
        }
        actualHeight = fixedHeight
        let openHeight = superview.frame.height-fixedHeight
        self.frame = CGRect(x: 0,
                            y: openHeight,
                            width: superview.frame.width,
                            height: fixedHeight)
        self.lastY = openHeight
        self.isHidden = false
        self.finishSetup()
    }
    
    func hide(animated: Bool, completion: (() -> Void)? = nil) {
        guard let superview = self.superview, !self.isHidden else {
            return
        }
        
        if animated {
            UIView.animate(withDuration: 0.250, delay: 0.0, options: [.curveEaseOut], animations: {
                self.frame.origin.y = superview.frame.height
            }) { (done) in
                self.isHidden = true
                completion?()
            }
        } else {
            self.frame.origin.y = superview.frame.height
            self.isHidden = true
            completion?()
        }
    }
    
    func show(animated: Bool, completion: (() -> Void)? = nil) {
        guard self.isHidden else {
            return
        }
        
        self.isHidden = false
        if animated {
            UIView.animate(withDuration: 0.250, delay: 0.0, options: [.curveEaseOut], animations: {
                self.frame.origin.y = self.lastY
            }) { (done) in
                completion?()
            }
        } else {
            self.frame.origin.y = self.lastY
            completion?()
        }
    }
    
    private func finishSetup() {
        self.dropShadow(color: .black, opacity: 0.2, offSet: CGSize.zero, radius: 5, scale: true)
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        
        let point = gestureRecognizer.translation(in: self.superview)
        let velocity = gestureRecognizer.velocity(in: self.superview)
        
        guard abs(velocity.y) > abs(velocity.x) else { return }
        
        switch gestureRecognizer.state {
        case .began:
            self.originalCenter = self.center
        case .changed:
            let yOffset = self.originalCenter.y + point.y
            var finalY = CGFloat(0.0)
            
            if velocity.y < 0 {
                //up
                finalY = max(self.limitPullup, yOffset)
            } else {
                //down
                finalY = min(self.limitPulldown, yOffset)
            }

            view.center = CGPoint(x: self.originalCenter.x, y: finalY)
            print(abs(point.y))
            if abs(yOffset) > 35 {
                gestureRecognizer.isEnabled = false
                return
            }
            
        case .cancelled, .ended:
            /*
            let sorted = self.snaps!.sorted(by: {
                self.distance(from: view.frame.origin, to: $0) < self.distance(from: view.frame.origin, to: $1)
            })
            */
            self.endPan(velocity: velocity, view: view)
            gestureRecognizer.isEnabled = true
        default: break
        }
    }
    
    
    private func endPan(velocity: CGPoint, view: UIView) {
        /*
         let sorted = self.snaps!.sorted(by: {
         self.distance(from: view.frame.origin, to: $0) < self.distance(from: view.frame.origin, to: $1)
         })
         */
        guard let snaps = self.snaps else { return }
        var snapsPlusMe = snaps
        snapsPlusMe.append(view.frame.origin)
        let sortedSnaps = snapsPlusMe.sorted { $0.y < $1.y }
        
        var before: CGPoint?
        var after: CGPoint?
        for i in 0..<sortedSnaps.count {
            if sortedSnaps[i] == view.frame.origin, i > 0, i < sortedSnaps.count-1 {
                before = sortedSnaps[i-1]
                after = sortedSnaps[i+1]
            }
        }
        
        guard let beforePoint = before, let afterPoint = after else { return }
        
        if velocity.y < 0 {
            //up
            self.lastY = beforePoint.y
        } else {
            //down
            self.lastY = afterPoint.y
        }
        /*
         UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
         view.frame.origin.y = self.lastY
         }, completion: nil)
         */
        
        
        UIView.animate(withDuration: 0.250, delay: 0, options: .curveEaseOut, animations: {
            view.frame.origin.y = self.lastY
        }) { (success) in
            self.delegate?.gesturePanEnded(endY: self.lastY)
        }
    }
    
    private func convertSnaps(snaps: [CGFloat], height: CGFloat) -> [CGPoint] {
        var snapsPoints: [CGPoint] = []
        for i in 0..<snaps.count {
            let y = height-snaps[i]
            snapsPoints.append(CGPoint(x: 0.0, y: y))
        }
        
        return snapsPoints
    }
    
    private func distance(from lhs: CGPoint, to rhs: CGPoint) -> CGFloat {
        let xDistance = lhs.x - rhs.x
        let yDistance = lhs.y - rhs.y
        return (xDistance * xDistance + yDistance * yDistance).squareRoot()
    }

    private func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func updateHeight(with height: CGFloat) {
        guard let superview = self.superview else {
            return
        }
        let openHeight = superview.frame.height-height
        self.frame = CGRect(x: 0,
                            y: openHeight,
                            width: superview.frame.width,
                            height: height)
    }
}
