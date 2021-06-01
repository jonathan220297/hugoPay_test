//
//  FilteredTransactionRequest.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 19/4/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct FilteredTransactionRequest: APIRequest {
    public typealias Response = LatestTransactionsResponse

    public var resourceName: String {
        var components = URLComponents()
        components.path = "api/v2/transaction/getTransactions"
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "client_id", value: client_id))
        if let start_date = start_date, start_date != "" {
            queryItems.append(URLQueryItem(name: "start_date", value: start_date))
        }
        if let end_date = end_date, end_date != "" {
            queryItems.append(URLQueryItem(name: "end_date", value: end_date))
        }
        if let movement_type = movement_type, movement_type != "" {
            queryItems.append(URLQueryItem(name: "movement_type", value: movement_type))
        }
        if let payment_type = payment_type, payment_type != "" {
            queryItems.append(URLQueryItem(name: "payment_type", value: payment_type))
        }
        if let start_amount = start_amount {
            queryItems.append(URLQueryItem(name: "start_amount", value: String(start_amount)))
        }
        if let end_amount = end_amount {
            queryItems.append(URLQueryItem(name: "end_amount", value: String(end_amount)))
        }
        components.queryItems = queryItems
        return components.url?.absoluteString ?? ""
    }

    public let client_id: String
    public let start_date: String?
    public let end_date: String?
    public let movement_type: String?
    public let payment_type: String?
    public let start_amount: Double?
    public let end_amount: Double?
}
