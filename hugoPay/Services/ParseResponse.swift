//
//  ParseResponse.swift
//  Transportation
//
//  Created by Juan Jose Maceda on 7/7/19.
//  Copyright © 2019 Hugo Technologies. All rights reserved.
//

import Foundation

struct ParseResponse<Response: Decodable>: Decodable {
    public let result: Response?
}

