//
//  Address.swift
//  Hugo
//
//  Created by Juan Jose Maceda on 12/9/16.
//  Copyright © 2016 Clever Mobile Apps. All rights reserved.
//

import Foundation
import Parse

class Address: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Address"
    }
    
    var _id: String? {
        get { return self["_id"] as? String }
        set { self["_id"] = newValue }
    }
    
    var friendly_name: String? {
        get { return self["friendly_name"] as? String }
        set { self["friendly_name"] = newValue }
    }
    
    var address_type: Int? {
        get { return self["address_type"] as? Int }
        set { self["address_type"] = newValue }
    }
    
    var geo: PFGeoPoint? {
        get { return self["geo"] as? PFGeoPoint }
        set { self["geo"] = newValue }
    }
    
    var address: String? {
        get { return self["address"] as? String }
        set { self["address"] = newValue }
    }
    
    var address_geo: String? {
        get { return self["address_geo"] as? String }
        set { self["address_geo"] = newValue }
    }
    
    var address_num: String? {
        get { return self["address_num"] as? String }
        set { self["address_num"] = newValue }
    }
    
    var city: String? {
        get { return self["city"] as? String }
        set { self["city"] = newValue }
    }
    
    var depto: String? {
        get { return self["depto"] as? String }
        set { self["depto"] = newValue }
    }
    
    var profile_id: Profile? {
        get { return self["profile_id"] as? Profile }
        set { self["profile_id"] = newValue }
    }
    
    var is_default: Bool? {
        get { return self["is_default"] as? Bool }
        set { self["is_default"] = newValue }
    }
    
    var reference: String? {
        get { return self["reference"] as? String }
        set { self["reference"] = newValue }
    }
    
    var segment: String? {
        get { return self["segment"] as? String }
        set {
            self["segment"] = newValue
        }
    }
    
    var territory: String? {
        get { return self["territory"] as? String }
        set {
            self["territory"] = newValue
        }
    }
    
    var country: String? {
        get { return self["country"] as? String }
        set {self["country"] = newValue}
    }
    
    var territory_name: String? {
        get { return self["territory_name"] as? String }
        set {
            self["territory_name"] = newValue
        }
    }

    var symbol: String? {
        get { return self["symbol"] as? String }
        set {
            self["symbol"] = newValue
        }
    }
    
    var currency: String? {
        get { return self["currency"] as? String }
        set {
            self["currency"] = newValue
        }
    }
    
    var dec_point: String? {
        get { return self["dec_point"] as? String }
        set {
            self["dec_point"] = newValue
        }
    }
    
    var thousands_sep: String? {
        get { return self["thousands_sep"] as? String }
        set {
            self["thousands_sep"] = newValue
        }
    }
    
    var timezone: String? {
        get { return self["timezone"] as? String }
        set {
            self["timezone"] = newValue
        }
    }
    
    var is_zone_mode: Bool? {
        get { return self["is_zone_mode"] as? Bool }
        set {
            self["is_zone_mode"] = newValue
        }
    }
    
    var is_temp: Bool? {
        get { return self["is_temp"] as? Bool }
        set {
            self["is_temp"] = newValue
        }
    }
    
    var extra_info: String? {
        get { return self["extra_info"] as? String }
        set { self["extra_info"] = newValue }
    }
    
    var is_selected: Bool = false
    
    var getGeoAsString: String? {
        var geo_string = ""
        if let geo_object = self.geo {
            geo_string = "\(geo_object.latitude), \(geo_object.longitude)"
        }
        
        return geo_string
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        var address_geo = ""
        if let geo = self.geo {
            address_geo = "\(geo.latitude),\(geo.longitude)"
        }
        
        let friendly_name = self.friendly_name ?? ""
        let address = self.address ?? ""
        let address_num = self.address_num ?? ""
        let reference = self.reference ?? ""
        let city = self.city ?? ""
        let depto = self.depto ?? ""
        let profile_id = self.profile_id?.objectId ?? ""
        let is_default = self.is_default ?? false
        let address_type = self.address_type ?? 0
        let segment = self.segment ?? ""
        let territory = self.territory ?? ""
        let country = self.country ?? ""
        let extra_info = self.extra_info ?? ""
        let currency = self.currency ?? "USD"
        let symbol = self.symbol ?? "$"
        let dec_point = self.dec_point ?? "."
        let thousands_sep = self.thousands_sep ?? ","
        let is_zone_mode = self.is_zone_mode ?? false
        let id = self._id ?? ""
        
        let dic: [String: Any] = ["friendly_address_name": friendly_name,
                                  "address_geo": address_geo,
                                  "address": address,
                                  "address_num": address_num,
                                  "city": city,
                                  "depto": depto,
                                  "address_profile_id": profile_id,
                                  "address_is_default": is_default,
                                  "address_type": address_type,
                                  "reference": reference,
                                  "segment": segment,
                                  "territory": territory,
                                  "country": country,
                                  "extra_info": extra_info,
                                  "currency": currency,
                                  "symbol": symbol,
                                  "dec_point": dec_point,
                                  "thousands_sep": thousands_sep,
                                  "is_zone_mode": is_zone_mode,
                                  "_id": id]
        
        return dic
    }
    
    override var description: String {
        return self.toDictionary().description
    }
    
}
