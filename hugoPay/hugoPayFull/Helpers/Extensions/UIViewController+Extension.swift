//
//  UIViewController+Extension.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/29/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

/// Enum to list each storyboard.
enum AppStoryboard: String {
    
    // List all the storyboards here.
    // swiftlint:disable identifier_name
    case HugoPayFull
    case CreateAccount
    case SendMoney
    case RequestMoney
    case HugoPayFullTutorial
    case HugoPayFullCashIn
    // swiftlint:enable identifier_name
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    /// Gets the instance of a view controller with a given type
    ///
    /// - Parameters:
    ///   - viewControllerClass: The Type for the view controller
    /// - Returns: The view controller instance
    func viewController<T: UIViewController>(viewControllerClass: T.Type,
                                             function: String = #function,
                                             line: Int = #line,
                                             file: String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            let viewController = "ViewController with identifier \(storyboardID)"
            let storyboard = "\(self.rawValue) Storyboard.\n"
            let file = "File : \(file) \n"
            let line = "Line Number : \(line) \n"
            let function = "Function : \(function)"
            fatalError("\(viewController), not found in \(storyboard)\(file)\(line)\(function)")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

// MARK: - Extending UIViewController
extension UIViewController {
    
    // Not using static as it wont be possible to override if one wants to provide custom storyboardID
    class var storyboardID: String {
        // This implementation assumes the same name for class name and storyboard identifier.
        // Reflection could be used to get the right invoking class name
        return "\(self)"
    }
    
    /// Instantiates a UIViewControl from a Storyboard
    ///
    /// - Parameter appStoryboard: the storyboard where the view is
    /// - Returns: the UIViewController
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    func viewContainingController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil
        
        return nil
    }
    
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
    
    func showLoading() {
        self.view.activityStartAnimating(activityColor: .black, backgroundColor: .lightGray)
    }
    
    func hideLoading() {
        self.view.activityStopAnimating()
    }
}

extension UIView {
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIApplication
            .shared
            .windows
            .filter { $0.isKeyWindow }
            .first?
            .rootViewController?
            .topMostViewController()
    }
}
