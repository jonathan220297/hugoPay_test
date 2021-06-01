//
//  HugoPayTutorialResponse.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 19/5/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

// MARK: - HugoPayTutorialResponse
struct HugoPayTutorialResponse: Codable {
    let success: Bool?
    let message: String?
    let code: Int?
    let data: [HugoPayTutorialData]?
}

// MARK: - HugoPayTutorialData
struct HugoPayTutorialData: Codable {
    let page: Int?
    let image: String?
    let title: TitleTutorial?
    let content: [ContentPageTutorial]?
}

// MARK: - ContentPageTutorial
struct ContentPageTutorial: Codable {
    let text: String?
    let bold: [String]?
    let type: TypeEnum?
}

enum TypeEnum: String, Codable {
    case button = "button"
    case text = "text"
}

// MARK: - TitleTutorial
struct TitleTutorial: Codable {
    let text: String?
    let bold: [String]?
}
