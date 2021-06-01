//
//  DoInsertRide.swift
//  Transportation
//
//  Created by Victor Gamero Ortega on 7/10/19.
//  Copyright © 2019 Hugo Technologies. All rights reserved.
//

import Foundation

struct DoInsertRide: APIRequest {
    public typealias Response = InsertRide
    
    public var resourceName: String {
        return "insertride"
    }
    
    public let territory: String
    public let service: String
    public let client_id: String
    public let client_geo_origin: String
    public let client_address_origin: TransportationAddress
    public let client_geo_destination: String
    public let client_address_destination: TransportationAddress
    public let payment_type: String
    public let price: Double
    public let vehicle_type: String
    public let charge_vars: ChargeVars
    public let eta_fee: EtaFee
    public let ride_id: String
    public let cc_info : CcInfo
    public let app: String = "IOS"
    public let build: String = buildVersion()
    public let api : String = "V2"
    public let stops : [TransportationAddress]
    public let client_device_info: String =  "iOS - " + hugoVersion()
    public let player_id: String
    
    struct TransportationAddress: Encodable {
        public let _id: String
        public let title: String
        public let address: String
        public let geo: String
        public var arrival_time_unix: Int?
    }

    struct ChargeVars: Encodable {
        public let basic_rate: Double
        public let booking_fee: Double
        public let time_fee: Double
        public let distance_fee: Double
        public let driver_percentage: Double
    }

    struct EtaFee: Encodable {
        public let time_charge:Double
        public let distance_charge:Double
        public let ride_cost:Double
        public let process_cost:Double
    }

    struct CcInfo: Encodable {
        public let cardNum: String
        public let cardType: String
        public let cardExp: String
        public let cardCvv: String
        public let cardId: String
    }

}
