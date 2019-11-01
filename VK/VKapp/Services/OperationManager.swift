//
//  OperationManager.swift
//  VKapp
//
//  Created by Юрий Султанов on 01.10.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class OperationManager {
    var operationsInProgress = [IndexPath: Operation]()
    var filteringQ: OperationQueue = {
        var q = OperationQueue()
        q.maxConcurrentOperationCount = 7
        q.name = "com.heduxar.operations"
        q.qualityOfService = .default
        return q
    }()
}
