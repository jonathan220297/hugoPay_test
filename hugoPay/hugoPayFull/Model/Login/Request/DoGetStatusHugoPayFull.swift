//
//  DoGetStatusHugoPayFull.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 27/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct DoGetStatusHugoPayFull: APIRequest {
    public typealias Response = GetStatusHugoPayFullResponse
    
    public var resourceName: String {
        return "api/v1/client/get-client"
    }
    
    public let client_id: String
    public let app: String = "IOS"
    public let build: String = buildVersion()
    public let client_device_info: String =  "iOS - " + hugoVersion()
}
