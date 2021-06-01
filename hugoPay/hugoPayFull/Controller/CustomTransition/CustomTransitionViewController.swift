//
//  CustomTransitionViewController.swift
//  Hugo
//
//  Created by Ali Gutierrez on 4/10/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit


open class CustomTransitionViewController: UIViewController, UIViewControllerTransitioningDelegate {

    open override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            .fullScreen
        }
        set {}
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
    }
    
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        FadeTransition(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        FadeTransition(transitionDuration: 0.5, startingAlpha: 0.8)
    }
}
