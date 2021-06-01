//
//  ConfigurationsRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct ConfigurationsRequest: APIRequest {
    
    public typealias Response = ConfigurationsResponse
    
    public var resourceName: String {
        return "api/v2/menu/configClientMenu?country=\(country_name)"
    }

    public let country_name: String
}
