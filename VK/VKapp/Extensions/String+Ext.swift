//
//  File.swift
//  VKapp
//
//  Created by Юрий Султанов on 08.09.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

extension String {
    public func FirestoreArray(_ text: String) -> [String: Any] {
        let date = Date()
        let key = date.toString(dateFormat: "dd-MM-yyyy HH:mm")
        return [ key : text ]
    }
}
