//
//  DoGetCardList.swift
//  Hugo
//
//  Created by Developer on 6/30/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation
import UIKit

struct DoGetTokenizeCustomerCCs: APIRequest {
    public typealias Response = GetCardList
    
    public var resourceName: String {
        return "customer_cc_list/\(customer_id)"
    }
    
    public let customer_id: String


}
