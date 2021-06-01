//
//  UIViewController+keyboard.swift
//  Transportation
//
//  Created by Juan Jose Maceda on 8/28/19.
//  Copyright © 2019 Hugo Technologies. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    
    func hideKeyboardToResponse(){
        let tapdismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapdismiss.numberOfTapsRequired = 1
        if let delegate = self as? UIGestureRecognizerDelegate{
            tapdismiss.delegate = delegate
        }
        tapdismiss.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapdismiss)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func subscribeForKeyboardNotification(selector: Selector) {
        NotificationCenter.default.addObserver(
            self,
            selector: selector,
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: selector,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: selector,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: selector,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
}
