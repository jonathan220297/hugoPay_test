//
//  TransactionsListRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 31/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct TransactionsListRequest: APIRequest {
    public typealias Response = LatestTransactionsResponse

    public var resourceName: String {
        var components = URLComponents()
        components.path = "api/v2/transaction/getTransactions"
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "client_id", value: client_id))
        if let today = today {
            if today {
                queryItems.append(URLQueryItem(name: "today", value: String(today)))
            }
        }
        if let this_month = this_month {
            if this_month {
                queryItems.append(URLQueryItem(name: "this_month", value: String(this_month)))
            }
        }
        if let previous_transactions = previous_transactions {
            if previous_transactions {
                queryItems.append(URLQueryItem(name: "previous_transactions", value: String(previous_transactions)))
            }
        }
        components.queryItems = queryItems
        return components.url?.absoluteString ?? ""
//        return "api/v2/transaction/getTransactions?client_id=\(client_id)"
    }

    public let client_id: String
    public let today: Bool?
    public let this_month: Bool?
    public let previous_transactions: Bool?
}
