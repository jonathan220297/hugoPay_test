//
//  Constants.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/18/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

var PARSE_APP_ID = ""
var PARSE_URL = ""
var VGS_URL = ""
var ASSETS_URL = ""
var PAYMENT_URL = ""
var GOOGLE_API_URL = ""
var GOOGLE_URL_TOPUP = ""
var USER_API_URL = ""
var ELASTIC_URL = ""

//currency
var CURRENCY_SYMBOL = "$"
var CURRENCY = "USD"
var DECIMAL_SEP = "."
var THOUSAND_SEP = ","

struct ErrorNotifications {
    static let INVALID_SESSION_TOKEN = "com.hugoapp.client.invalid_session_token"
}

enum HugoPay {
    
    enum ExpensesControl {
        enum Categories {
            static let food = "comida"
            static let home = "hogar"
            static let transportation = "transporte"
            static let leisure = "ocio"
            static let health = "salud"
            static let other = "otro"
        }
        
        enum Colors {
            static let food = "D2B6F0"
            static let home = "3fe1c7"
            static let transportation = "fdb9b6"
            static let leisure = "fed56d"
            static let health = "ff8243"
            static let other = "85818B"
        }
    }
    
    enum UI {
        static let pullUpViewCornerRadius = CGFloat(20)
    }
}
