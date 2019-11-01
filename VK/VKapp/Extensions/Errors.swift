//
//  Errors.swift
//  VKapp
//
//  Created by Юрий Султанов on 18.10.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import Foundation

enum VKError: Error {
    case someError(message: String)
}

extension VKError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .someError(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
