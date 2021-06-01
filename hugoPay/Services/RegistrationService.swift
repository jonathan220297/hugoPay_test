//
//  RegistrationService.swift
//  Hugo
//
//  Created by Developer on 4/23/19.
//  Copyright © 2019 Clever Mobile Apps. All rights reserved.
//

import UIKit
import Parse
import FirebaseAuth

enum PhoneLoginAction: String {
    case enter_phone_num = "enter_phone_num"
    case check_code = "check_code"
    case services = "services"
    case check_code_and_create_pwd = "check_code_and_create_pwd"
    case check_with_pwd = "check_with_pwd"    
    case profile_exists = "profile_exists"
    case locate_me = "locate_me"
    case configure_pwd = "configure_pwd"
    case fb_enter_phone = "enter_phone_num_fb"
    case fb_profile_exists = "fb_profile_exists"
    case fb_account_not_match = "fb_account_not_match"
    case fb_check_code = "fb_check_code"
    case check_code_editing = "check_code_editing"
    case phone_already_exists = "phone_already_exists"
    case profile_locked = "profile_locked"
}

enum RecoveryPasswordType: String {
    case check_code_recovery_pwd = "check_code_recovery_pwd"
    case select_method_send_code = "select_method_send_code"

}

class RegistrationService: NSObject {
    let newUser = NewRegistrationUser.shared
    let userManager = UserManager.shared
    let userData = UserData.shared

    //MARK: - Check Profile
    func newCheckProfile(handler: @escaping (_ success: Bool,_ created: Bool, _ profile_id: String?, _ action: String?) -> Void) -> Void {
        var params = createNewParams()
        
        if let device_id =  UIDevice.current.identifierForVendor?.uuidString as String? {
            params["app_id"] = device_id
        } else {
            params["app_id"] = ""
        }
        
        if let userId = PFUser.current()?.objectId {
            params["user_id"] = userId
        } else {
            params["user_id"] = ""
        }

        params["player_id"] = userManager.player_id ?? ""
        params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)

        print(params)

        PFCloud.callFunction(inBackground: "checkProfile", withParameters: params, block: { [weak self] (response,error) in
            if error == nil {
                if let response = response as? [String: Any] {
                    if let created = response["created"] as? Bool,
                        let profile_id = response["profile_id"] as? String,
                        let display = response["display"] as? String,
                        let active = response["session_active"] as? Bool   {
                        if created{
                            self?.newUser.display = display
                            self?.userManager.profile_id = profile_id
                            self?.userManager.profile_idInvited = profile_id
                            handler(true, true, profile_id, display)
                            return
                        }
                        else {
                            self?.userManager.profile_id = profile_id
                            self?.userManager.profile_idInvited = profile_id
                            if active{
                                self?.userManager.`setBaseData`(response)
                            }
                            handler(true, false, profile_id, display)
                            return
                        }
                    }
                }
                print("fail to profile_id")
                handler(false, false, nil, nil)
                return
            } else if !handleParseError(error) {
                print("fail")
                handler(false, false, nil, nil)
                return
            }
        })
    }
    

    //MARK: - Send Code
    func getCountryCodes(handler: @escaping (_ coutryCodeList: [CountryCodeItem]?) -> Void){
        
        var items: [CountryCodeItem]?
        
        var params = Dictionary<String, Any>()
        params["app"] = "IOS"
        params["build"] = buildVersion()
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
        print("\(CloudEndPoints.NewAreaCodes) \(params)")
        PFCloud.callFunction(inBackground:  CloudEndPoints.NewAreaCodes, withParameters: params) { (result, error) in
            if error == nil, let data = result as? [[String: Any]] {
                let decoder = JSONDecoder()
                do {
                    items = try data.map({ (item: [String: Any]) in
                        let jsonData = item.json.data(using: .utf8)!
                        return try decoder.decode(CountryCodeItem.self, from: jsonData)
                    })
                } catch {
                    print(error)
                }
            }
            
            if !handleParseError(error) {
                handler(items)
            }
        }
    }

    func newSendCode(codeItem : CountryCodeItem, phone: String, handler: @escaping (_ success: Bool, _ action: String?, _ is_firebase: Bool?) -> Void) -> Void {
        var params = Dictionary<String, Any>()
        
        params["phone"] = phone
        params["country_code"] = codeItem.area_code
        params["country"] = codeItem.code
        params["profile_id"] = userManager.profile_id ?? ""

        params["app"] = "IOS"
        params["build"] = buildVersion()
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
        //374738
        print(params)
        PFCloud.callFunction(inBackground: "newsendcode", withParameters: params, block: { [weak self] (response,error) in
            if error == nil {
                if let response = response as? [String: Any] {
                    //handler(true)
                    if let action = response["display"] as? String,
                        let profile_id = response["profile_id"] as? String,
                        let phoneDisplay = response["phone_display"] as? String{
                        //self?.newUser?.smsType = codeItem.message_service {
                        //self.newUser?.code = response["code"] as? String
                        self?.newUser.display = action
                        self?.newUser.countryItem = codeItem
                        self?.newUser.phone = phone
                        self?.newUser.phoneDisplay = phoneDisplay
                        self?.newUser.count_session = response["count_session"] as? Int ?? 0
                        self?.newUser.clientName = response["client_name"] as? String ?? ""
                        self?.newUser.clientAvatar = response["client_avatar"] as? String ?? ""
                        self?.userManager.profile_id = profile_id
                        //let messageType = response["message_type_service"] as? String ?? ""
                        print(response)
                        handler(true, action, codeItem.is_firebase)
                        return
                    }
                }
                print("fail")
                handler(false, nil, nil)
                //handler(false)
                //handler(true)
            } else if !handleParseError(error) {
                print("fail")
                if let error = error {
                    let err = error as NSError
                    let code = err.code as Int
                    if code == 403{
                        handler(false, "blocked", nil)
                        return
                    }
                }
                handler(false, nil, nil)
            }
        })
    }
    

    func requestSMSFirebase(codeItem : CountryCodeItem, phone: String, handler: @escaping (_ success: Bool, _ action: String?) -> Void) -> Void{
        //let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let phoneNumber = "\(codeItem.area_code)\(phone)"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
            if let error = error {
                //self.showMessagePrompt(error.localizedDescription)
                print(error)
                handler(false, nil)
                return
            }


//            if let _ = self?.newUser{
//            } else {
//                self?.newUser = NewRegistrationUser()
//            }

            self?.newUser.verificationIDFirebase = verificationID
            //self?.newUser?.smsType = "firebase"
            //self?.newUser?.display = "check_code"
            self?.newUser.countryItem = codeItem
            self?.newUser.phone = phone
            self?.newUser.phoneDisplay = phoneNumber

            handler(true, self?.newUser.display)
            //UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            // Sign in using the verificationID and the code sent to the user
            // ...
        }
    }


    //MARK: - Verify Code
    func verifySMSFirebase(code: String, handler: @escaping (_ success: Bool, _ action: String?) -> Void) -> Void{
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.newUser.verificationIDFirebase ?? "",
                                                                 verificationCode: code)
        Auth.auth().signIn(with: credential) { authData, error in
            if (error != nil) {
                print("fail")
                handler(false, nil)
                return
            }
            //self.newUser?.display  = PhoneLoginAction.locate_me.rawValue
            handler(true, self.newUser.display)
            return
        }
    }
    
    func newVerifyCode(code: String, handler: @escaping (_ success: Bool, _ action: String?) -> Void) -> Void {
        var params = Dictionary<String, Any>()
        
//        guard  let user = self.newUser else{
//            return
//        }
        let user = newUser

        params["phone"] = user.phone
        params["country_code"] = user.countryItem?.area_code
        params["country"] = user.countryItem?.code
        params["profile_id"] = userManager.profile_id ?? ""
        params["display"] = user.display ?? ""
        params["code"] = code
        params["email"] = userManager.email ?? ""
        params["name"] = userManager.name ?? ""
        
        params["app"] = "IOS"
        params["build"] = buildVersion()
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
        
        PFCloud.callFunction(inBackground: "newverifycode", withParameters: params, block: { [weak self] (response,error) in
            if error == nil {
                if let response = response as? [String: Any] {
                    if let action = response["display"] as? String,
                        let profileid = response["profile_id"] as? String{
                        
                        self?.newUser.display  = action
                        self?.userManager.profile_id = profileid

                        if let clientid = response["client_id"] as? String{
                            self?.userManager.client_id = clientid
                        }
                        self?.userManager.phone = user.phone
                        if let token = response["session_token"] as? String,
                            let userid  = response["user_id"] as? String {
                            self?.userManager.session_token  = token
                            self?.userManager.user_id = userid
                            do {
                                try PFUser.become(token)
                            } catch let error{
                                print(error)
                            }
                        }
                        handler(true, action)
                        return
                    }
                }
                print("fail")
                handler(false, nil)
            } else if !handleParseError(error) {
                print("fail")
                handler(false, nil)
            }
        })
    }



    //MARK: - Password Recovery
    func forgottenPwdGetInfo(handler: @escaping (_ success: Bool, _ action: String?) -> Void) -> Void {
        var params = Dictionary<String, Any>()
        params["profile_id"] = userManager.profile_id ?? ""
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
        PFCloud.callFunction(inBackground: "pwdforgotten", withParameters: params, block: { (response,error) in
            if error == nil {
                if let response = response as? [String: Any] {
                    if let layout = response["layout"] as? String{

                        switch layout {
                        case RecoveryPasswordType.select_method_send_code.rawValue:
                            break
                        case RecoveryPasswordType.check_code_recovery_pwd.rawValue:
                            break
                        default:
                            break
                        }

                        handler(true, "")
                        return
                    }
                }
                print("fail")
                handler(false, nil)
            } else if !handleParseError(error) {
                print("fail")
                handler(false, nil)
            }
        })
    }
    
    //MARK: - Step 2
    func updatePicture(image: UIImage, handler: @escaping (_ success: Bool) -> Void) -> Void {
        var params = Dictionary<String, Any>()
        params["profile_id"] = userManager.profile_id ?? ""
        params["avatar"] = image.convertImageToBase64()
        params["step"] = "step_2"
        params["general_update"] = false
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)

        PFCloud.callFunction(inBackground: "updateclientprofile", withParameters: params, block: { (response,error) in
            if error == nil {
                if let response = response as? [String: Any] {
                    if let success = response["success"] as? Bool{
                        handler(success)
                        return
                    }
                }
                handler(false)
                return
            } else {
                handler(false)
                return
            }
        })
    }

    //MARK: - Get Profile
    func getUserData(handler: @escaping (_ success: Bool, _ userData: ProfileInfo?) -> Void) -> Void {
        var params = Dictionary<String, Any>()
        params["profile_id"] = userManager.profile_id ?? ""
        params["app"] = "IOS"
        params["build"] = buildVersion()
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
        print("getclientprofile \(params)")

        PFCloud.callFunction(inBackground: "getclientprofile", withParameters: params, block: {[weak self](response,error) in
            if error == nil {
                if let response = response as? [String: Any] {
                    if let pending = response["pending_steps"] as? Int{
                        self?.userData.pendingSteps = pending
                    }
                    let profileInfo: ProfileInfo
                    let decoder = JSONDecoder()
                    do {
                        let data = try JSONSerialization.data(withJSONObject: response, options: [])
                        profileInfo = try decoder.decode(ProfileInfo.self, from: data)
                        handler(true,profileInfo)
                        return
                    } catch {
                        print("error: \(error.localizedDescription)")
                        handler(false, nil)
                    }
                }
                handler(false, nil)

            } else if !handleParseError(error) {
                handler(false, nil)
            }
        })
    }

    //MARK: - Get Territory new user
    func setTerritory(_ territoryID: String?, handler: @escaping (_ success: Bool, _ territory: Territory?) -> Void) -> Void {
        var params = Dictionary<String, Any>()
        params["profile_id"] = userManager.profile_id ?? ""
        params["app"] = "IOS"
        params["territory"] = territoryID ?? ""
        params["build"] = buildVersion()
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
print("setclientterritory \(params)")
        PFCloud.callFunction(inBackground: "setclientterritory", withParameters: params, block: {(response,error) in
            if error == nil {
                if let response = response as? [String: Any] {
                    if let pending = response["pending_steps"] as? Int{
                        self.userData.pendingSteps = pending
                    }
                    let territory: Territory
                    let decoder = JSONDecoder()
                    do {
                        let data = try JSONSerialization.data(withJSONObject: response, options: [])
                        territory = try decoder.decode(Territory.self, from: data)
                        handler(true,territory)
                        return
                    } catch {
                        print("error: \(error.localizedDescription)")
                        handler(false, nil)
                    }
                }
                handler(false, nil)

            } else if !handleParseError(error) {
                handler(false, nil)
            }
        })
    }
    
    func setTerritoryGeo(_ geo: String, handler: @escaping (_ success: Bool, _ territory: Territory?) -> Void) -> Void {
        var params = Dictionary<String, Any>()
        params["profile_id"] = userManager.profile_id ?? ""
        params["geo"] = geo
        params["app"] = "IOS"
        params["build"] = buildVersion()
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
print("setclientterritory \(params)")
        PFCloud.callFunction(inBackground: "setclientterritory", withParameters: params, block: {(response,error) in
            if error == nil {
                if let response = response as? [String: Any] {
                    if let pending = response["pending_steps"] as? Int{
                        self.userData.pendingSteps = pending
                    }
                    let territory: Territory
                    let decoder = JSONDecoder()
                    do {
                        let data = try JSONSerialization.data(withJSONObject: response, options: [])
                        territory = try decoder.decode(Territory.self, from: data)
                        handler(true,territory)
                        return
                    } catch {
                        print("error: \(error.localizedDescription)")
                        handler(false, nil)
                    }
                }
                handler(false, nil)

            } else if !handleParseError(error) {
                handler(false, nil)
            }
        })
    }

    //MARK: - Request a Call
    func newVerifyCodeCall(_ type: String, _ email: String, _ recovery_type: String, handler: @escaping (_ success: Bool, _ message: String?) -> Void) -> Void {
        var params = Dictionary<String, Any>()

        let user = self.newUser
        params["type"] = type
        params["phone"] = user.phone
        params["area_code"] = user.countryItem?.area_code
        params["country"] = user.countryItem?.code
        params["profile_id"] = userManager.profile_id ?? ""
        params["client_email"] = email
        params["app"] = "IOS"
        params["build"] = buildVersion()
        params["recovery_type"] = recovery_type
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
        
        var message = "Error"
        var completed = false
print("callcode \(params)")
        PFCloud.callFunction(inBackground: "callcode", withParameters: params, block: {(response,error) in
            if error == nil {
                if let response = response as? [String: Any] {
                    if let success = response["success"] as? Bool, let text = response["message"] as? String {
                            completed = success
                            message = text
                        }
                        if let error = response["error"] as? String{
                            message = error
                        }
                    }
            } else if !handleParseError(error) {
                print("fail make call")
            }
            handler(completed, message)
        })
    }

    //MARK: - Edit phone
    //API para actualizar teléfono
    func editSendCode(codeItem : CountryCodeItem, phone: String, handler: @escaping (_ success: Bool, _ action: String?, _ messageType: String?) -> Void) -> Void {
        var params = Dictionary<String, Any>()

        params["phone"] = phone
        params["country_code"] = codeItem.area_code
        params["country"] = codeItem.code
        params["profile_id"] = userManager.profile_id ?? ""

        //params["dummy"] = true
        //params["success_attempts"] = 1

        params["app"] = "IOS"
        params["build"] = buildVersion()
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
        //374738
        print("getcodeupdatephone \(params)")
        PFCloud.callFunction(inBackground: "getcodeupdatephone", withParameters: params, block: { [weak self] (response,error) in
            if error == nil {
//                if let _ = self?.newUser{
//                } else {
//                    self?.newUser = NewRegistrationUser()
//                }
                if let response = response as? [String: Any] {
                    //handler(true)
                    if let success = response["success"] as? Bool{
                        //self.newUser?.code = response["code"] as? String
                        if success{
                            self?.newUser.display = "check_code_editing"
                            self?.newUser.countryItem = codeItem
                            self?.newUser.phone = phone
                            self?.newUser.phoneDisplay = "\(codeItem.area_code) \(phone)"
                            self?.newUser.clientName = response["client_name"] as? String ?? ""
                            self?.newUser.clientAvatar = response["client_avatar"] as? String ?? ""
                            //self?.userManager.profile_id = profile_id
                            let messageType = response["message_type_service"] as? String ?? ""
                            print(response)
                            handler(true, self?.newUser.display, messageType)
                            return
                        }
                        else {
                            handler(false, nil, nil)
                            return
                        }

                    }
                }
                print("fail")
                handler(false, nil, nil)
                return
            } else if !handleParseError(error) {
                print("fail")
                handler(false, nil, nil)
                return
            }
        })
    }

    func editVerifyCode(code: String, handler: @escaping (_ success: Bool, _ action: String?, _ message: String?) -> Void) -> Void {
        var params = Dictionary<String, Any>()

//        guard  let user = self.newUser else{
//            return
//        }
        let user = self.newUser
        params["phone"] = user.phone
        params["country_code"] = user.countryItem?.area_code
        params["country"] = user.countryItem?.code
        params["profile_id"] = userManager.profile_id ?? ""
        params["code"] = code
        if let is_firebase = user.countryItem?.is_firebase, is_firebase
        {
            params["avoid_code"] = true
        }
        params["app"] = "IOS"
        params["build"] = buildVersion()
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
print("updateclientphone \(params)")
        PFCloud.callFunction(inBackground: "updateclientphone", withParameters: params, block: { [weak self] (response,error) in
            if error == nil {
                if let response = response as? [String: Any] {
                    //handler(true)
                    if let success = response["success"] as? Bool {

                        if success{
                        self?.newUser.display  = "services"
                        handler(true, self?.newUser.display, nil)
                        return
                        } else {
                            if let message = response["message"] as? String{
                            print("fail updatephone")
                            handler(false, nil, message)
                            return
                            }
                            handler(false, nil, "Hubo un error en la actualización, intentalo más tarde")
                            return
                        }
                    }
                }
                print("fail parsing")
                handler(false, nil, "Hubo un error en la actualización, intentalo más tarde")
                return
                //handler(false)
                //handler(true)
            } else if !handleParseError(error) {
                print("fail error")
                handler(false, nil, "Hubo un error en la actualización, intentalo más tarde")
                return
            }
        })
    }

    //MARK: - Verify Code
    func editVerifySMSFirebase(code: String, handler: @escaping (_ success: Bool, _ action: String?) -> Void) -> Void{
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.newUser.verificationIDFirebase ?? "",
                                                                 verificationCode: code)
        Auth.auth().signIn(with: credential) { authData, error in
            if (error != nil) {
                print("fail")
                handler(false, nil)
                return
            }
            //self.newUser?.display  = PhoneLoginAction.locate_me.rawValue
            self.newUser.display  = "services"
            handler(true, "services")
            return
        }
    }

}
