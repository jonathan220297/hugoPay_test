//
//  RegisterPinHPFullResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct RegisterPinHPFullResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: InitDataHugoPayFull?
}
