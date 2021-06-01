//
//  DoGetSetDefault.swift
//  Hugo
//
//  Created by Developer on 7/17/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation
struct DoGetSetDefault: APIRequest {
    public typealias Response = GetSetDefault
    
    public var resourceName: String {
         return "set-default-cc/\(card_id)/customer/\(customer_id)"
    }
    
    public let customer_id  : String
    public let card_id : String
   
    
}
