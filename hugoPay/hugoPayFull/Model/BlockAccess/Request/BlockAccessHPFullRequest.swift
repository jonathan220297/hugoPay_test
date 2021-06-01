//
//  BlockAccessHPFullRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct BlockAccessHPFullRequest: APIRequest {

    public typealias Response = BlockAccessHPFullResponse

    public var resourceName: String {
        return "api/v2/client/blockAccess"
    }

    public let client_id: String
}
