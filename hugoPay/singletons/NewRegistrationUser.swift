//
//  NewRegistrationUser.swift
//  Hugo
//
//  Created by Developer on 5/8/19.
//  Copyright © 2019 Clever Mobile Apps. All rights reserved.
//

import UIKit

class NewRegistrationUser: NSObject {

    static let shared = NewRegistrationUser()
    var phone: String?
    var code: String?
    var countryItem: CountryCodeItem?
    var display: String?
    var phoneDisplay: String?
    var verificationIDFirebase: String?
    var clientName: String?
    var clientAvatar: String?
    var count_session: Int = 0
    var exist_phone: Bool?
    var message_result: String?

    func getPhoneNumber() -> String {
        if let phone = self.phone,  let countryItem = self.countryItem{
            return "\(countryItem.area_code) \(phone)"
        }
        return ""
    }
    
    func userPhone() -> String? {
        guard let country = countryItem,
            let phone = phone else {
                
                return nil
        }
        return "\(country.area_code)\(phone)"
    }
}
