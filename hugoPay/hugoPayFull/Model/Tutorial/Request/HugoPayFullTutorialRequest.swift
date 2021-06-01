//
//  HugoPayFullTutorialRequest.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 19/5/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

class HugoPayFullTutorialRequest: APIRequest {
    public typealias Response = HugoPayTutorialResponse

    public var resourceName: String {
        return "api/v2/client/tutorial"
    }
}
