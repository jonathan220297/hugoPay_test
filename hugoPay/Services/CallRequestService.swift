//
//  CallRequestHelper.swift
//  Hugo
//
//  Created by Developer on 5/16/19.
//  Copyright © 2019 Clever Mobile Apps. All rights reserved.
//

import Parse
import Foundation

class CallRequestService {
    
    func callRequest(_ objectId: String, _ type: String, _ subject: String, _ clientId: String, _ territory: String, handler: @escaping messageResponse) {
        var params = createNewParams()
        params["type"] = type
        params["subject"] = subject
        params["client_id"] = clientId
        params["territory"] = territory
        
        if type != "general" {
            if type == "order" || type == "order_delivered" {
                params["order_id"] = objectId
            } else {
                params["ride_id"] = objectId
            }
        }
        
        cloudCallRequest(params: params, completition: handler)
    }
    
    func sendCallRequest(type: String, subject: String, country: String, completition: @escaping messageResponse) {
        var params = createNewParams()
        params["type"] = type
        params["client_id"] = ""
        params["subject"] = subject
        params["country"] = country
        
        cloudCallRequest(params: params, completition: completition)
    }
    
    private func cloudCallRequest(params: Dictionary<String, Any>, completition: @escaping messageResponse) {
        var msg = AlertString.helpRequestFailedMessage
        var completed = false
        print("\(CloudEndPoints.CallRequest) \(params)")
        PFCloud.callFunction(inBackground: CloudEndPoints.CallRequest, withParameters: params, block: { (response, error) in
            if error == nil {
                completed = true
                
                if let response = response as? [String: Any], let success = response["success"] as? Bool {
                    msg = AlertString.helpRequested
                    completed = success
                }
            }
            
            completition(completed, msg)
        })
    }
    
    func callRequestNewRegister(params: [String: Any], completition: @escaping messageResponse) {
        var msg = AlertString.helpRequestFailedMessage
        var completed = false
        print("\(CloudEndPoints.CallRequestNewRegister) \(params)")
        PFCloud.callFunction(inBackground: CloudEndPoints.CallRequestNewRegister, withParameters: params, block: { (response, error) in
            if error == nil {
                completed = true
                
                if let response = response as? [String: Any], let success = response["success"] as? Bool {
                    msg = response["message"] as! String
                    completed = success
                    if completed{
                        msg = AlertString.helpRequested
                    }
                }
            }
            
            completition(completed, msg)
        })
    }
    
}
