//
//  AcceptTermsHugoPayResponse.swift
//  Hugo
//
//  Created by Rodrigo Bazan on 7/9/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation
struct AcceptTermsHugoPayResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: InitDataHugoPay?
}
