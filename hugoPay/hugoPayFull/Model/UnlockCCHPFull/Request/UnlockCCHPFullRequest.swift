//
//  UnlockCCHPFullRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 28/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct UnlockCCHPFullRequest: APIRequest {
    public typealias Response = UnlockCCHPFullResponse
    
    public var resourceName: String {
        return "api/v2/card/cardUnlock"
    }
    
    public let isVirtualCard: Bool
    public let client_id: String
}
