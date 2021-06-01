//
//  TutorialStepsRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 31/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct TutorialStepsRequest: APIRequest {

    public typealias Response = TutorialStepsResponse

    public var resourceName: String {
        return "api/v2/client/clientTutorialNumber?client_id=\(client_id)"
    }

    public let client_id: String
}
