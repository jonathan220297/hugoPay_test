//
//  ProcessCashInResponse.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 26/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct ProcessCashInResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: DataCashIn?
}

struct DataCashIn: Decodable {
    public let hugo_id: String?
    public let balance : String?
}
