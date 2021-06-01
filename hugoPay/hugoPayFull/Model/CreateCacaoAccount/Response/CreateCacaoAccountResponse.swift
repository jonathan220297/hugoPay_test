//
//  CreateCacaoAccountResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 19/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct CreateCacaoAccountResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
//    public let data: InitDataHPFull?
}
