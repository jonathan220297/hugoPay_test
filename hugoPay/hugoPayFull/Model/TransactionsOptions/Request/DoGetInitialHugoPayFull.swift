//
//  DoGetInitialHugoPayFull.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 30/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct DoGetInitialHugoPayFull: APIRequest {

    public typealias Response = GetInitialHPFullResponse

    public var resourceName: String {
        return "api/v2/menu/homeMenu?country=\(country_name)"
    }

    public let country_name: String
}
