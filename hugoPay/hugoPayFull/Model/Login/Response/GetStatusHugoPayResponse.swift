//
//  GetStatusHugoPayResponse.swift
//  Hugo
//
//  Created by Rodrigo Bazan on 7/7/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct GetStatusHugoPayResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: InitDataHugoPay?
}

struct InitDataHugoPay : Decodable{
    public var id : Int?
    public var pin : String?
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
    public var screen : String?
    public var read_instructions : Bool?
}

enum VerifyHugoPayLayout: String {
    case login = "login"
    case onBoarding = "onBoarding"
    case onboarding = "onboarding"
    case create_acount = "create_acount"
    case hugo_pay = "hugo_pay"
}
