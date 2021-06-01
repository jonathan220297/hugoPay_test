//
//  FadeTransition.swift
//  Hugo
//
//  Created by Ali Gutierrez on 4/10/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit


open class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var transitionDuration: TimeInterval = 0.5
    var startingAlpha: CGFloat = 0.0

    public convenience init(transitionDuration: TimeInterval, startingAlpha: CGFloat){
        self.init()
        self.transitionDuration = transitionDuration
        self.startingAlpha = startingAlpha
    }

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toView   = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!

        toView.alpha   = startingAlpha
        fromView.alpha = 0.8
        
        toView.frame = containerView.frame
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { () -> Void in
            toView.alpha   = 1.0
            fromView.alpha = 0.0
            }, completion: { _ in
                fromView.alpha = 1.0
                transitionContext.completeTransition(true)
        })
    }
}
