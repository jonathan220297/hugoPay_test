//
//  UserServices.swift
//  Hugo
//
//  Created by Developer on 5/18/19.
//  Copyright © 2019 Clever Mobile Apps. All rights reserved.
//

import Parse
import Foundation

class UserService {

    typealias params = Dictionary<String, Any>
    typealias response = (_ success: Bool) -> ()

    func login(params: params, completition: @escaping (_ token: String?, _ data: [String : Any]?) ->()) {
        print("loginclient \(params)")
        PFCloud.callFunction(inBackground: "loginclient", withParameters: params) { (response, error) in
            var token = ""
            var info : [String : Any]?
            
            if let data = response as? [String: Any], let session_token = data["session_token"] as? String {
                info = data
                token = session_token
            }
            
            completition(token, info)
        }
    }
    
    func loginWithFB(params: params, completition: @escaping (_ result: [String : Any]?, _ error: Error?) ->()) {
        print("fbloginclient \(params)")
        PFCloud.callFunction(inBackground: "fbloginclient", withParameters: params) { (response, error) in
            var userInfo: [String : Any]?
            
            if let response = response as? [String : Any] {
                userInfo = response
            }
            completition(userInfo, error)
        }
    }

    func updatePassword(params: params, completition: @escaping (_ success: Bool, _ token: String?) -> ()) {
        print("updateclientpassword \(params)")
        PFCloud.callFunction(inBackground: "updateclientpassword", withParameters: params) { (response, error) in
            var token = ""
            var success = false
            
            
            if let response = response as? [String: Any],
                let updated = response["success"] as? Bool {
                success = updated
                
                if let session_token = response["session_token"] as? String {
                    token = session_token
                }
            }
            
            completition(success, token)
        }
    }
    
    func requestRecoveryCode(params: params, completition: @escaping response) {
        print("recoverycode \(params)")
        PFCloud.callFunction(inBackground: "recoverycode", withParameters: params) { (response, error) in
            var success = false
            
            if let data = response as? [String: Any], let _ = data["profile_id"] as? String {
                success = true
            }
            
            completition(success)
        }
    }
    
    func validateRecoveryCode(params: params, completition: @escaping response) {
        print("validaterecoverycode \(params)")
        PFCloud.callFunction(inBackground: "validaterecoverycode", withParameters: params) { (response, error) in
            var success = false
            
            if let data = response as? [String: Any],  let _ = data["profile_id"] as? String {
                success = true
            }
            
            completition(success)
        }
    }

    func updateClientProfile(params: params, completition: @escaping response) {
        print("updateclientprofile \(params)")
        PFCloud.callFunction(inBackground: "updateclientprofile", withParameters: params) { (response, error) in
            var success = false

            if let data = response as? [String: Any], let updated = data["success"] as? Bool {
                success = updated
            }

            completition(success)
        }
    }

    func verifyNewAddress(params: params, completition: @escaping (_ success: Bool, _ result: [String : Any]?) -> ()) {
        print("checkaddressrange \(params)")
        PFCloud.callFunction(inBackground: "checkaddressrange", withParameters: params) { (response, error) in
            var success = false
            var result : [String : Any]?

            if let data = response as? [String: Any], let updated = data["success"] as? Bool {
                success = updated
                result = data
            }

            completition(success, result)
        }
    }

    
}
