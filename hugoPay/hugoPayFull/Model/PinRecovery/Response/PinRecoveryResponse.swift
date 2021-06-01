//
//  PinRecoveryResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 02/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

import Foundation

struct PinRecoveryResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: PinSentHPFull?
}

struct PinSentHPFull : Decodable{
    public var pin_sent : Bool?
}
