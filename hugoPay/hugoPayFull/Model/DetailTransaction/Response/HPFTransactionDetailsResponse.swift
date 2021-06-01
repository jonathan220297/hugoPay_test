//
//  DetailTransactionHPFullResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct DetailTransactionHPFullResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: DataDetailTransactionHPFull?
}

struct DataDetailTransactionHPFull: Decodable {
    public let id: Int?
    public let hugoId: String?
    public let date: String?
    public let service: String?
    public let partnerName: String?
    public let locationName: String?
    public let divisa: String?
    public let cardNumber: String?
    public let cardBrand: String?
    public let type: String?
    public let totalAmount: Double?
    public let totalAmountLabel: String?
    public let cardAmount: Double?
    public let cardAmountLabel: String?
    public let cashback: Double?
    public let cashbackLabel: String?
    public let status: String?
    public let note: String?
    public let userType: String?
    public let clientName: String?
    public let clientPhone: String?
    public let paymentType: String?
    
    enum CodingKeys: String, CodingKey {
        case id, date, service, divisa, type, cashback, status, note
        case hugoId = "hugo_id"
        case partnerName = "partner_name"
        case locationName = "location_name"
        case cardNumber = "card_number"
        case cardBrand = "card_brand"
        case totalAmount = "total_amount"
        case totalAmountLabel = "total_amount_label"
        case cardAmount = "card_amount"
        case cardAmountLabel = "card_amount_label"
        case cashbackLabel = "cashback_label"
        case userType = "user_type"
        case clientName = "client_name"
        case clientPhone = "client_phone"
        case paymentType = "payment_type"
    }
}

struct RequestMoneyTransactionDetailsResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: RequestMoneyTransactionDetailsData?
}

struct RequestMoneyTransactionDetailsData: Decodable {
    public let receiverName: String?
    public let phone: String?
    public let email: String?
    public let country: String?
    public let registerDate: String?
    public let dueDate: String?
    public let type: String?
    public let logo : String?
    public let status: String?
    public let amount: String?
    public let note: String?
    
    enum CodingKeys: String, CodingKey {
        case receiverName = "receiver_name"
        case registerDate = "register_date"
        case dueDate = "due_date"
        case phone, email, country, type, logo, status, amount, note
    }
}
