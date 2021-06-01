//
//  SplashHPFullViewController.swift
//  hugoPay
//
//  Created by Jonathan  Rodriguez on 1/6/21.
//

import UIKit
import Parse

class SplashHPFullViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        PARSE_APP_ID = APDLGT.PRS1D
        PARSE_URL = APDLGT.PRSR
        ASSETS_URL = APDLGT.A55T5R
        PAYMENT_URL = APDLGT.P4YR
        USER_API_URL = APDLGT.USERUR1
        VGS_URL = APDLGT.VGSURL
        
        // Parse
        Parse.initialize(with: ParseClientConfiguration {
            $0.applicationId = PARSE_APP_ID
            $0.server = PARSE_URL
        })
    }
    
}
