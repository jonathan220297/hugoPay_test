//
//  CashinConfigurationRequest.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 12/4/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct CashinConfigurationRequest: APIRequest {

    public typealias Response = CashinConfigurationResponse

    public var resourceName: String {
        return "api/v2/transaction/cashIn/settings?country=\(country)"
    }

    public let country: String
}
