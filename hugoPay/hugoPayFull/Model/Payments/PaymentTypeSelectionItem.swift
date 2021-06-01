//
//  PaymentTypeSelectionItem.swift
//  HugoPay
//
//  Created by Jonathan  Rodriguez on 31/5/21.
//

import Foundation

struct PaymentTypeSelectionItem {
    var name: String?
    var type: PaymentType
    var card: CardObject?
}

struct PaymentTypeItem: Decodable {
    var name: String
    var type: String
    var code_required: Bool
    var instructions_title: String
    var instructions_content: String
    var require_voucher: Bool
}

struct ScheduleBanner: Encodable {
    internal init(content: String?, show: Bool?) {
        self.content = content
        self.show = show
    }
    var content: String?
    var show: Bool?
}

enum PaymentType: String {
    case Cash       = "cash"
    case CC         = "CC"
    case Redeem     = "redeem"
    case zelle      = "zelle"
    case Pago_movil = "pago_movil"
    case Paypal     = "paypal"
    case Reserve    = "reserve"
    case People_pay = "people_pay"
    case Venmo      = "venmo"
}
