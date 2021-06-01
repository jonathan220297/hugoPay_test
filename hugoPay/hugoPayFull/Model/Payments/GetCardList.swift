//
//  GetCardList.swift
//  Hugo
//
//  Created by Developer on 6/30/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct GetCardList: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: [CardObject]?
}

struct CardObject: Decodable {
    public var id           : String?
    public var card_name    : String?
    public var card_identifier_name : String?
    public var card_holder  : String?
    public var card_color   : String?
    public var cc_end       : String?
    public var cc_start     : String?
    public var cc_brand     : String?
    public var blocked      : Bool?
    public var enabled      : Bool?
    public var is_default   : Bool?
    public var created_at   : String?
    public var updated_at   : String?
    
}
