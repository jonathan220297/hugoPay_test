//
//  RequestMoneyResponse.swift
//  Hugo
//
//  Created by Ali Gutierrez on 4/15/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct RequestMoneyResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: RequestMoneyResponseData?
}

struct RequestMoneyResponseData: Decodable {
    public let created: Bool?
    public let transactionId: Int?

    enum CodingKeys: String, CodingKey {
        case created
        case transactionId = "id"
    }
}
