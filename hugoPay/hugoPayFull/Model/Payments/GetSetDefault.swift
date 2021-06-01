//
//  GetSetDefoult.swift
//  Hugo
//
//  Created by Developer on 7/17/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation
struct GetSetDefault: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: dataResponse?
}


struct dataResponse: Decodable {
   
}
