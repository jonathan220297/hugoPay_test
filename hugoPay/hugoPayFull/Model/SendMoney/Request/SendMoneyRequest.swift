//
//  SendMoneyRequest.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/31/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct SendMoneyRequest: APIRequest {
    
    public typealias Response = SendMoneyResponse
    
    public var resourceName: String {
        return "api/v1/transactionp2p/sendMoney"
    }

    public let clientId: String
    public let receiver: SendMoneyReceiver
    public let amount: Double
    public let note: String
    public let appVersion: String
    public let deviceType: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case appVersion = "app_version"
        case deviceType = "device_type"
        case receiver, amount, note
    }
    
}

struct SendMoneyReceiver: Codable {
    public let email: String?
    public let phone: String?

    enum CodingKeys: String, CodingKey {
        case email = "_email"
        case phone = "_phone"
    }
}

