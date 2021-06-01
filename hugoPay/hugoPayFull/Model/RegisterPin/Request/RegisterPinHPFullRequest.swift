//
//  RegisterPinHPFullRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct RegisterPinHPFullRequest: APIRequest {
    
    public typealias Response = RegisterPinHPFullResponse
    
    public var resourceName: String {
        return "api/v2/client/registerPin"
    }
    
    public let pin: String
    public let client_id: String
}
