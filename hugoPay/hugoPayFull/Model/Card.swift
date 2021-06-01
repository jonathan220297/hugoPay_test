//
//  Card.swift
//  Hugo
//
//  Created by Juan Jose Maceda on 12/9/16.
//  Copyright © 2016 Clever Mobile Apps. All rights reserved.
//

import Foundation

class Card: NSObject {
    
    var CLIENTE_TRANS_TARJETAMAN: String?
    var CLIENTE_TRANS_TARJETAVEN: String?
    var CLIENTE_TRANS_TOKENCVV: String?
    
    var key: String?
    var cc_start: String?
    var cc_end: String?
    var identifier: String?
    var name_on_card: String?
    var card_brand_id: Int?
    var card_month_exp: String?
    var card_year_exp: String?
    var card_cvc: String?
    var card_number: String?
    var client_id: String?
    var is_default: Bool?
    var enabled: Bool?
    var color: String?
    
    func toDictionary() -> Dictionary<String, Any> {
        let key = self.key ?? ""
        let identifier = self.identifier ?? ""
        let name_on_card = self.name_on_card ?? ""
        let card_number = self.card_number ?? ""
        let card_brand_id = self.card_brand_id ?? 0
        let card_month_exp = self.card_month_exp ?? ""
        let card_year_exp = self.card_year_exp ?? ""
        let card_cvc = self.card_cvc ?? ""
        let client_id = self.client_id ?? ""
        let cc_start = self.cc_start ?? ""
        let cc_end = self.cc_end ?? ""
        let is_default = self.is_default ?? false
        let enabled = self.enabled ?? false
        let color = self.color ?? ColorCC.Purple.rawValue
        
        
        return ["key": key, "identifier": identifier, "name_on_card": name_on_card, "card_number": card_number, "card_brand_id": card_brand_id, "card_month_exp": card_month_exp, "card_year_exp": card_year_exp, "card_cvc": card_cvc, "client_id": client_id, "cc_start": cc_start, "cc_end": cc_end, "is_default": is_default, "enabled": enabled, "color": color]
    }
    
    func toDictionaryShipment() -> Dictionary<String, Any> {
        let card_number = self.card_number ?? ""
        let card_brand = card_number.customCardType()?.customStringValue() ?? ""
        let card_exp = "\(self.card_month_exp ?? "")\(self.card_year_exp ?? "")"
        let card_cvc = self.card_cvc ?? ""
        
        return ["cardNum": card_number, "cardType": card_brand, "cardExp": card_exp, "cardCvv": card_cvc]
    }
    

    func toCcInfo() -> DoInsertRide.CcInfo {
        let card_number = self.card_number ?? ""
        let card_brand = card_number.customCardType()?.customStringValue() ?? ""
        let card_exp = "\(self.card_month_exp ?? "")\(self.card_year_exp ?? "")"
        let card_cvc = self.card_cvc ?? ""
        let ccInfo =  DoInsertRide.CcInfo(cardNum: card_number, cardType: card_brand, cardExp: card_exp, cardCvv: card_cvc, cardId: "")
        return ccInfo
    }

    
    
    override var description: String {
        return self.toDictionary().description
    }
}
