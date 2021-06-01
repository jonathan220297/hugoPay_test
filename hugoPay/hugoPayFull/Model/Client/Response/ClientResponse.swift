//
//  ClientResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 10/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct ClientResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: InitDataHPFull?
}

struct InitDataHPFull : Decodable{
    public var is_first_time : Bool?
    public var client_id : String?
    public var profile_id : String?
    public var biometrics : Bool?
    public var app_id_biometrics : String?
    public var name : String?
    public var phone : String?
    public var email : String?
    public var is_block : Bool?
    public var cashback : Double?
    public var accept_terms : Bool?
    public var onboarding : Bool?
    public var read_instructions : Bool?
    public var screen : String?
}
