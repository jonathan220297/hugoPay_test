//
//  BlockCCHPFullRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 28/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct BlockCCHPFullRequest: APIRequest {
    public typealias Response = BlockCCHPFullResponse
    
    public var resourceName: String {
        return "api/v2/card/cardLock"
    }
    
    public let isVirtualCard: Bool
    public let client_id: String
}
