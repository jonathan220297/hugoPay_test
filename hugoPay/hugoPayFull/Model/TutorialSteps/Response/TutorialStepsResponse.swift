//
//  TutorialStepsResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 31/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct TutorialStepsResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: [TutorialSteps]?
}

struct TutorialSteps: Decodable {
    public let tutorial_1: Bool?
    public let tutorial_2: Bool?
    public let tutorial_3: Bool?
}
