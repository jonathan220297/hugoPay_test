//
//  UserData.swift
//  Hugo
//
//  Created by Developer on 5/22/19.
//  Copyright © 2019 Clever Mobile Apps. All rights reserved.
//

import UIKit

class UserData: NSObject {

    static let shared = UserData()
    
    
    var pendingSteps: Int?
    var profileInfo: ProfileInfo?
    var recoverInfo: RecoverPassword?
    

    func getInitials() -> String?{
        guard let name = self.profileInfo?.client_name, !name.isEmpty else {
            return nil
        }
        let separate_name = name.components(separatedBy: " ")
        if separate_name.count > 1, !separate_name[0].isEmpty, !separate_name[1].isEmpty{
            let first_letter = String(separate_name[0][separate_name[0].startIndex])
            let second_letter = String(separate_name[1][separate_name[1].startIndex])

            return "\(first_letter)\(second_letter)"
        } else {
            if !name.isEmpty {
                return String(name[(name.startIndex)])
            }
            return nil
        }
    }
    
    private func createProfileInfo() {
        self.profileInfo = ProfileInfo()
    }

    func saveProfileInfo(param: [String: String]) {
        if profileInfo == nil {
            createProfileInfo()
        }
        
        if let name = param["name"] {
            profileInfo?.client_name = name
        }
        if let email = param["email"] {
            profileInfo?.client_email = email
        }
        if let phone = param["phone"] {
            profileInfo?.client_phone = phone
        }
        if let client_id = param["client_id"] {
            profileInfo?.client_id = client_id
        }
        if let profile_id = param["profile_id"] {
            profileInfo?.profile_id = profile_id
        }
        if let client_image = param["client_image"] {
            profileInfo?.client_image = client_image
        }
    }
}

enum OptionRecoverType {
    case email
    case phone
    case whatsapp
}

enum Step: String {
    case step_1 = "step_1"
    case step_2 = "step_2"
    case step_3 = "step_3"
    case step_4 = "step_4"
    case step_5 = "step_5"
}

enum RecoverLayoutAction: String {
    case code = "check_code_recovery_pwd"
    case select = "select_method_send_code"
}

struct OptionRecoverPassword {
    var type: OptionRecoverType
    var masked_info: String
    var public_info: String
}

struct RecoverPassword: Codable {
    var profile_id: String
    var phone: String
    var masked_phone: String
    var email: String?
    var masked_email: String?
    var code_send_to: String?
    var layout: String
}

struct ProfileInfo: Codable {
    var profile_id : String?
    var client_id : String?
    var user_id : String?
    var client_image : String?
    var client_phone : String?
    var credit_count : Float?
    var debit_count : Float?
    var masked_email: String?
    var prize_data : PrizeData?
    var current_address : String?
    var client_name : String?
    var client_email : String?
    var gender : String?
    var birth_date : String?
    var name_message : String?
    var email_message : String?
    var step_message : String?
    var next_step_label : String?
    var current_step : Int?
    var total_steps : Int?
    var next_step : String?
    var btn_label : String?
    var count_session: Int?
}

struct PrizeData: Codable {
    var prize_count: Int?
    var prize_list : [PrizeList]?
}

struct PrizeList: Codable {
    var coupon: String?
    var title: String?
    var count: Int?
}

struct CountryCodeItem: Codable {
    var code: String
    var name: String
    var area_code: String
    var phone_length: Int?
    var max_length: Int?
    var min_length: Int?
    var message_service: String?
    var flag_img : String?
    var is_firebase : Bool?
    var call_active : Bool?
}
