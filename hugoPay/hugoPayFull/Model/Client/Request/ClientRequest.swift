//
//  ClientRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 10/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct ClientRequest: APIRequest {

    public typealias Response = ClientResponse

    public var resourceName: String {

        return "api/v2/client/getClient?client_id=\(client_id)"
    }

    public let client_id: String
}
