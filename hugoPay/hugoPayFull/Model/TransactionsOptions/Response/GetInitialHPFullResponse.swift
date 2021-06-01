//
//  GetInitialHPFullResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 30/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct GetInitialHPFullResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: [HomeHPFullOptions]?
}

struct HomeHPFullOptions : Decodable {
    public let text: String?
    public let image: String?
    public let type: String?
    public let items: [MenuHPFull]?
}

struct MenuHPFull : Decodable {
    public let text: String?
    public let image: String?
    public let type: String?
    public let enable: Bool?
}
