//
//  CardsAvailablesResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 28/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct CardsAvailablesResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: [CCHugoPayFull]?
}

struct CCHugoPayFull: Decodable {
    public let cardNumber: String?
    public let dueDateString: String?
    public let status: String?
    public let balance: String?
    public let isPhysical: Bool?
}
