//
//  TransactionEnums.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 19/4/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

enum TransactionFullMovementType: String {
    case inc = "INC"
    case exp = "EXP"
}

enum TransactionPaymentType: String {
    case hugoPay = "hugoPay"
    case other = "other"
    case all = ""
}

enum TransactionViewMore {
    case today
    case month
    case previous
}
