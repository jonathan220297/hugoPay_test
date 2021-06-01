//
//  BiometricsHugoPayFullResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct BiometricsHugoPayFullResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: InitDataHugoPay?
}
