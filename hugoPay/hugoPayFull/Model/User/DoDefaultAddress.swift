//
//  DoDefaultAddress.swift
//  Hugo
//
//  Created by Developer on 10/8/19.
//  Copyright © 2019 Clever Mobile Apps. All rights reserved.
//

import UIKit

struct DoDefaultAddress: APIRequest {
    public typealias Response = DefaultAddress

    public var resourceName: String {
        return "getdefaultaddress"
    }

    public let profile_id: String
    public let app: String = "IOS"
    public let build: String = buildVersion()
    public let api: String = "V1"
}
