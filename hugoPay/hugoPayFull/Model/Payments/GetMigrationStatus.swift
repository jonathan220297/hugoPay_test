//
//  GetMigrationStatus.swift
//  Hugo
//
//  Created by Developer on 7/13/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation
import UIKit

struct GetMigrationStatus: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: dataStatus?
}


struct dataStatus: Decodable {
    public let did_migration: Bool?
    public let extra_number_required: Bool?
}
