//
//  Territory.swift
//  HugoPay
//
//  Created by Jonathan  Rodriguez on 31/5/21.
//

import Foundation

protocol TerritoryProtocol {
    
}

struct Country: Codable, TerritoryProtocol {
    var name: String
    var code: String
    var flag: String
    var flag_img: String?
}

struct Territory: Codable, TerritoryProtocol {
    var _id: String
    var name: String
    var country: String
    var timezone: String
    var is_zone_mode: Bool
    var center_point: CenterPoint?
    var symbol: String?
    var currency: String?
    var dec_point: String?
    var thousands_sep: String?
}

struct CenterPoint: Codable {
    var lat: Double?
    var lng: Double?
}

enum TerritoryType: String {
    case COUNTRY = "COUNTRY"
    case TERRITORY = "TERRITORY"
}
