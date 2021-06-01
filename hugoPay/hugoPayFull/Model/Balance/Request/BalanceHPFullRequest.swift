//
//  BalanceHPFullRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 28/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct BalanceHPFullRequest: APIRequest {
    public typealias Response = BalanceHPFullResponse
    
    public var resourceName: String {
        return "api/v2/client/getBalance?client_id=\(client_id)"
    }

    public let client_id: String
}
