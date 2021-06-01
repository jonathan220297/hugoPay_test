//
//  DoGetMigrationStatus.swift
//  Hugo
//
//  Created by Developer on 7/13/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation
struct DoGetMigrationStatus: APIRequest {
    public typealias Response = GetMigrationStatus
    
    public var resourceName: String {
         return "customer-migration-status/\(customer_id)/\(country_id)"
    }
    
    public let customer_id  : String
    public let country_id : String
   
    
}
