//
//  HugoPayTutorialUpdateStatusRequest.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 21/5/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct HugoPayTutorialUpdateStatusRequest: APIRequest {
    public typealias Response = HugoPayTutorialUpdateStatusResponse

    public var resourceName: String {
        return "api/v2/client/updateTutorialStatus"
    }
    
    public let client_id: String
    public let screen_number: Int
    public let tutorial_finished: Bool
}
