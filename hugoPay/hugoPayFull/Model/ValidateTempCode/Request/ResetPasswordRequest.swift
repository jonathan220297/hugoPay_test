//
//  ResetPasswordRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 02/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct ResetPasswordRequest: APIRequest {

    public typealias Response = ResetPasswordResponse

    public var resourceName: String {
        return "api/v2/client/validateTempCode"
    }

    public let pin: Int
    public let client_id: String
}
