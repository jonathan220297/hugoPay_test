//
//  SendMoneyResponse.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/31/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct SendMoneyResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: SendMoneyResponseData?
}

struct SendMoneyResponseData: Decodable {
    public let created: Bool?
    public let transactionId: String?

    enum CodingKeys: String, CodingKey {
        case created
        case transactionId = "id"
    }
}

enum RecipientType: String {
    case phone = "PHONE"
    case email = "EMAIL"
    case contact = "CONTACT"
    case undetermined = "UNDETERMINED"
}
