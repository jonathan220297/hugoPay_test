//
//  ConfigurationsResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct ConfigurationsResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: [ConfigOptionsHPFull]?
}

struct ConfigOptionsHPFull : Decodable {
    public let header: [ConfigHeaderHPFull]?
    public let body: [ConfigBodyHPFull]?
}

struct ConfigHeaderHPFull : Decodable {
    public let text: String?
    public let type: String?
}

struct ConfigBodyHPFull : Decodable {
    public let title: String?
    public let comment: String?
    public let image: String?
    public let type: String?
}
