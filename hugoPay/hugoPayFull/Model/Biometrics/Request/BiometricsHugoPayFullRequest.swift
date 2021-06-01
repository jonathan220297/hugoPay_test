//
//  BiometricsHugoPayFullRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct BiometricsHugoPayFullRequest: APIRequest {
    public typealias Response = BiometricsHugoPayFullResponse
    
    public var resourceName: String {
        return "api/v2/client/biometricSettings"
    }
    
    public let client_id: String
    public let app_id: String
    public let biometrics: Bool
}
