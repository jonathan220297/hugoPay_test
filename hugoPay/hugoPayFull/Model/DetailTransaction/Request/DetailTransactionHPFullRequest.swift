//
//  DetailTransactionHPFullRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct DetailTransactionHPFullRequest: APIRequest {

    public typealias Response = DetailTransactionHPFullResponse

    public var resourceName: String {
        return "api/v2/transaction/detail?hugo_id=\(hugo_id)"
    }

    public let hugo_id: String
}

struct RequestMoneyTransactionDetailRequest: APIRequest {
   
    public typealias Response = RequestMoneyTransactionDetailsResponse
    
    public var resourceName: String {
        return "api/v1/transactionp2p/detail?request_id=\(request_id)"
    }
    
    public let request_id: String
}
