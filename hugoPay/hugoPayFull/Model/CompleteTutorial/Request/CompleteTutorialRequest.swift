//
//  CompleteTutorialRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct CompleteTutorialRequest: APIRequest {

    public typealias Response = CompleteTutorialResponse

    public var resourceName: String {
        return "api/v2/client/updateTutorialStatus"
    }

    public let client_id: String
    public let screen_number: Int
}
