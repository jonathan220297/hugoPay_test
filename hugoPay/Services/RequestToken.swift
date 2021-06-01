//
//  RequestToken.swift
//  Transportation
//
//  Created by Juan Jose Maceda on 8/27/19.
//  Copyright © 2019 Hugo Technologies. All rights reserved.
//

import Foundation

class RequestToken {
    private weak var task: URLSessionDataTask?
    
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    func cancel() {
        task?.cancel()
    }
}
