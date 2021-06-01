//
//  InsertRide.swift
//  Transportation
//
//  Created by Victor Gamero Ortega on 7/10/19.
//  Copyright © 2019 Hugo Technologies. All rights reserved.
//

import Foundation

struct InsertRide: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: DataInsertRide?

}

struct DataInsertRide: Decodable {
    public let ride_id: String?
    public let action_done: String?
    public let last_drop_off_route: String?
}
