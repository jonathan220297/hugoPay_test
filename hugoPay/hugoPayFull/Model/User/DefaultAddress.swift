//
//  DefaultAddress.swift
//  Hugo
//
//  Created by Developer on 10/8/19.
//  Copyright © 2019 Clever Mobile Apps. All rights reserved.
//

import UIKit

struct DefaultAddress: Decodable {
    public let success: Bool?
    public let data: DefaultAddressData?
    public let message: String?
    public let code: Int?
}

struct DefaultAddressData: Decodable {
    let _id: String?
    let geo: [Double]?
    let address: String?
    let city: String?
    let depto: String?
    let address_num: String?
    let reference: String?
    let friendly_name: String?
    let address_type: Int?
    let segment: String?
    let is_default: Bool?
    let _p_profile_id: String?
    let territory: String?
    let country: String?
    let timezone: String?
    let is_zone_mode: Bool?
    let symbol: String?
    let currency: String?

    func getGeoAsString() -> String? {
        var geo_string = ""
        if let geo_object = self.geo {
            geo_string = "\(geo_object[1]), \(geo_object[0])"
        }

        return geo_string
    }
}

