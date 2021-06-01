//
//  RequestMoneyRequest.swift
//  Hugo
//
//  Created by Ali Gutierrez on 4/15/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct RequestMoneyRequest: APIRequest {
    
    public typealias Response = RequestMoneyResponse
    
    public var resourceName: String {
        return "api/v1/transactionp2p/requestMoney"
    }

    public let clientId: String
    public let receiver: RequestMoneyReceiver
    public let amount: Double
    public let note: String

    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case receiver, amount, note
    }
    
}

struct RequestMoneyReceiver: Codable {
    public let email: String?
    public let phone: String?

    enum CodingKeys: String, CodingKey {
        case email = "_email"
        case phone = "_phone"
    }
}
