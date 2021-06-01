//
//  VerifyPinRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct VerifyPinRequest: APIRequest {
    public typealias Response = VerifyPinResponse

    public var resourceName: String {
        return "api/v2/client/Login"
    }

    public let client_id: String
    public let pin: String?
    public let biometrics: Bool?
    public let app_id: String?
}
