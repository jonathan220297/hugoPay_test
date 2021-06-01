//
//  OnboardingHPFullRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 27/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct OnboardingHPFullRequest: APIRequest {

    public typealias Response = OnboargindHPFullResponse
    
    public var resourceName: String {
        return "api/v2/menu/onboardingMenu?country=\(country_name)"
    }

    public let country_name: String
}
