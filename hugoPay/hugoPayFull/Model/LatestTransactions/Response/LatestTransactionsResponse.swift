//
//  LatestTransactionsResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 30/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct LatestTransactionsResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: [DataTransactionsHPFull]?
}

struct DataTransactionsHPFull: Decodable {
    public let label: String?
    public let transactions : [TransactionsHPFull]?
    let viewMore: Bool?
    let section: String?
    
    enum CodingKeys: String, CodingKey {
        case label, transactions
        case viewMore = "view_more"
        case section
    }
}

struct TransactionsHPFull: Decodable {
    let id: Int?
    let hugoID, label, type, date: String?
    let amount, logo, movementType, status: String?
    let issuerName, receiverName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case hugoID = "hugo_id"
        case label, type, date, amount, logo
        case movementType = "movement_type"
        case status
        case issuerName = "issuer_name"
        case receiverName = "receiver_name"
    }
}

enum TransactionMovementType: String {
    case expense = "EXP"
    case income = "INC"
}

enum VerifyHPFullTypeLayout: String {
    case env = "TRANS" // Envio P2P - Rojo EB6D5A
    case req = "REQ" // Solicitud P2P - Gris C5BFD3
    case pos = "POS" // Pago en POS - Rojo EB6D5A
    case dep = "DEP" // Deposito en banco - Verde 073934
    case ret = "RET" // Retiro en ATM - Rojo EB6D5A
    case cca = "CCA" // Compra con Cashin - Rojo EB6D5A
    case cash = "CAI" // Fondeo de tarjeta hugo - Gris C5BFD3
    case qr = "QR" // pago con codigo QR - Rojo EB6D5A
}

enum TransactionHPFullStatus: String {
    case successful = "PS"
    case entered = "PI"
    case refund = "PR"
    case canceled = "PC"
    case declined = "PD"
}
