//
//  ProcessCashInRequest.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 26/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct ProcessCashInRequest: APIRequest {

    public typealias Response = ProcessCashInResponse

    public var resourceName: String {
        return "api/v2/transaction/cash-in"
    }

    public let client_id: String
    public let amount: Double
    public let country: String
    public let cc_end: String
    public let card_type: String
    public let id_card: String
    public let app_version: String
    public let device_type: String
}
