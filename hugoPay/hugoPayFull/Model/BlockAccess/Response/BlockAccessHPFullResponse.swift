//
//  BlockAccessHPFullResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct BlockAccessHPFullResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: BlockUserHPFull?
}

struct BlockUserHPFull : Decodable {
    public var client_id : String?
    public var is_block : Bool?
}
