//
//  LatestTransactionsRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 30/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct LatestTransactionsRequest: APIRequest {

    public typealias Response = LatestTransactionsResponse

    public var resourceName: String {
        return "api/v2/transaction/getLatestTransactions?client_id=\(client_id)"
    }

    public let client_id: String
}
