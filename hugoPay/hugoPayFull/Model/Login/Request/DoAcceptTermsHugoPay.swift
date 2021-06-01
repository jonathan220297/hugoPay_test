//
//  DoAcceptTermsHugoPay.swift
//  Hugo
//
//  Created by Rodrigo Bazan on 7/9/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation
struct DoAcceptTermsHugoPay: APIRequest {
    public typealias Response = AcceptTermsHugoPayResponse
    
    public var resourceName: String {
        return "api/v1/client/terms-and-conditions"
    }
    
    public let client_id: String
    public let app: String = "IOS"
    public let build: String = buildVersion()
    public let client_device_info: String =  "iOS - " + hugoVersion()
}
