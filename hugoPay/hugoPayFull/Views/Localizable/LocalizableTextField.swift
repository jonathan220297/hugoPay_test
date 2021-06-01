//
//  LocalizableTextField.swift
//  SegurosComedica
//
//  Created by Jonathan Rodriguez on 8/25/20.
//  Copyright © 2020 Syntepro. All rights reserved.
//

import Foundation
import UIKit

class LocalizableTextField: UITextField {
    @IBInspectable var translationKey: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let key = self.translationKey {
            self.placeholder = key.localized
        } else {
            assertionFailure("Translation not set for \(self.placeholder ?? "")")
        }
    }
}
