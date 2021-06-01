//
//  CashbackBalanceRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 02/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct CashbackBalanceRequest: APIRequest {
    public typealias Response = CashbackBalanceResponse

    public var resourceName: String {
        return "api/v2/cashback/global?client_id=\(client_id)&country=\(country_name)"
    }

    public let client_id: String
    public let country_name: String
}
