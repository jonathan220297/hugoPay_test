//
//  OnboargindHPFullResponse.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 27/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct OnboargindHPFullResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let code: Int?
    public let data: [OnboardingHPFullData]?
}

struct OnboardingHPFullData: Decodable {
    public let title: [OnboardingHPFullText]?
    public let body: [OnboardingHPFullText]?
    public let image: String?
    public let extra: ExtraOnboardingHPFullText?
}

struct OnboardingHPFullText: Decodable{
    public let text: String?
    public let size: Int?
    public let font: Int?
}

struct ExtraOnboardingHPFullText: Decodable {
    public let text : String?
    public let background_color: String?
    public let show : Bool?
}
