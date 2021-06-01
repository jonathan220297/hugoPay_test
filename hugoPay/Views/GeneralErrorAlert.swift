//
//  GeneralErrorAlert.swift
//  Hugo
//
//  Created by Rodrigo Bazan on 4/22/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import UIKit

class GeneralErrorAlert: UIView {
    
    @IBOutlet weak var titleError: UILabel!
    @IBOutlet weak var messageError: UILabel!
    @IBOutlet weak var generalErrorButton: UIButton!

    var close: (()->())?
    
    class func instantiateFromNib() -> GeneralErrorAlert {
        return Bundle.main.loadNibNamed("GeneralErrorAlert", owner: nil, options: nil)!.first as! GeneralErrorAlert
    }
    
    func populateError(_ title: String, _ message: String){
        titleError.text = title
        messageError.text = message
        generalErrorButton.makeHugoButton(title: "lbl_Ready".localizedString)
    }
    
    func populateGeneralError(_ code: String){
        let message = "\(Strings.GeneralErrorMsg)" + "Code".localizedString + ": (\(code))"
        
        titleError.text = Strings.GeneralErrorTitle
        messageError.text = message
        generalErrorButton.makeHugoButton(title: "lbl_Ready".localizedString)
    }
    
    @IBAction func closeGeneralError(_ sender: Any) {
        close?()
    }
    
}
