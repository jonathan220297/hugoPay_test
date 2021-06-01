//
//  HugoPayTutorialUpdateStatusResponse.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 21/5/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

// MARK: - HugoPayTutorialUpdateStatusResponse
struct HugoPayTutorialUpdateStatusResponse: Codable {
    let success: Bool?
    let message: String?
    let code: Int?
    let data: [String]?
}
