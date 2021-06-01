//
//  CashbackBalanceResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 02/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct CashbackBalanceResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: CashbackBalance?
}

struct CashbackBalance: Decodable {
    public let cashback: Double?
    public let cashback_label: String?
}
