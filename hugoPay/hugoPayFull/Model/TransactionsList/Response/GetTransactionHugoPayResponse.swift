//
//  GetTransactionHugoPayResponse.swift
//  Hugo
//
//  Created by Rodrigo Bazan on 7/20/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct GetTransactionHugoPayResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: DataTransactionHugoPay?
}

struct DataTransactionHugoPay: Decodable {
    public let id_transaction : String?
    public let info_partner : InfoPartnerTransactionHugoPay?
    public let info_amount : InfoAmountTransactionHugoPay?
    public let info_cashback : InfoCashbackTransactionHugoPay?
    
}

struct InfoPartnerTransactionHugoPay: Decodable {
    public let name_partner : String?
    public let name_location : String?
    public let id_partner : String?
    public let id_location : String?
    public let logo : String?
}

struct InfoAmountTransactionHugoPay : Decodable {
    public let amount_label : String?
    public let amount : Double?
}

struct InfoCashbackTransactionHugoPay : Decodable {
    public let amount_label : String?
    public let amount : Double?
    public let use_cashback: Bool?
}
