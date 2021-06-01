//
//  CashinConfigurationResponse.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 12/4/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

// MARK: - CashinConfigurationResponse
struct CashinConfigurationResponse: Codable {
    let success: Bool?
    let message: String?
    let code: Int?
    let data: CashinConfigurationData?
}

// MARK: - DataClass
struct CashinConfigurationData: Codable {
    let country, currency: String?
    let minAmount: Int?
    let minAmountLabel: String?

    enum CodingKeys: String, CodingKey {
        case country, currency
        case minAmount = "min_amount"
        case minAmountLabel = "min_amount_label"
    }
}
