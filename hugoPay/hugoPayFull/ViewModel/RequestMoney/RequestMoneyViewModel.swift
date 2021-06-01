//
//  RequestMoneyViewModel.swift
//  Hugo
//
//  Created by Ali Gutierrez on 4/15/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class RequestMoneyViewModel: NSObject {
    
    var countryData: CountryCodeItem?
    
    var userManager = UserManager.shared
    var isUSingContact = false
    var phoneNumber = ""
    var email = ""
    
    var fieldsNeedInput: Bool {
        phoneNumber.isEmpty && email.isEmpty
    }
    
    var textfieldShouldShake: Bool {
        !email.isEmpty && !isValidEmail(email)
    }
    
    func verifyRequestMoneyInfo(with amountText: String) -> Bool {
        let amount = amountText
            .replacingOccurrences(of: userManager.symbol ?? "$", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: " ", with: "")
        guard let amountAsDouble = Double(amount) else { return false }
        
        if amount.isEmpty {
            return false
        }
        
        if amountAsDouble <= 0.00 {
            return false
        }
        
        if fieldsNeedInput {
            return false
        }
        
        if textfieldShouldShake {
            return false
        }
        
        return true
    }
    
    func showMessagePrompt(_ error: String) {
        let alert  = UIAlertController(title: "AProblemOcurredTitle".localizedString , message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: AlertString.OK, style: .default, handler: nil)
        alert.addAction(action)
        
        let vc = getCurrentViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            
            return currentController
        }
        
        return nil
    }
}
