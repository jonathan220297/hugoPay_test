//
//  GoogleResponse.swift
//  Hugo
//
//  Created by Rodrigo Bazan on 3/30/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import UIKit

struct GoogleResponse<Response: Decodable>: Decodable{
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: Response?
}
