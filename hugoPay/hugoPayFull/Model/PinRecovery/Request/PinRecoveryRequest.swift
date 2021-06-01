//
//  PinRecoveryRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 02/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct PinRecoveryRequest: APIRequest {

    public typealias Response = PinRecoveryResponse

    public var resourceName: String {
        return "api/v2/client/pinRecovery"
    }

    public let client_id: String
    public let recovery_method: String
}
