//
//  GetTutorialTextsHugoPayResponse.swift
//  Hugo
//
//  Created by Carlos Landaverde on 12/4/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct GetTutorialTextsHugoPayResponse: Decodable {
    
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: [TutorialTextsHugoPay]?
    
}

struct TutorialTextsHugoPay: Decodable {
    
    public let welcome: [TutorialTextRowHugoPay]?
    public let card: [TutorialTextRowHugoPay]?
    public let cashback: [TutorialTextRowHugoPay]?
    public let recharge: [TutorialTextRowHugoPay]?
    public let control: [TutorialTextRowHugoPay]?
    public let Services: [TutorialTextRowHugoPay]?
    public let Transactions: [TutorialTextRowHugoPay]?
    public let QR: [TutorialTextRowHugoPay]?
    public let Done: [TutorialTextRowHugoPay]?
    
}

struct TutorialTextRowHugoPay: Decodable {
    
    public let text: String?
    public let type: String?
    public let description: String?
    public let next_screen: String?
    
}
