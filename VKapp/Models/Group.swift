//
//  Group.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

struct Group {
    var id: UInt
    var avatar: UIImage?
    var name: String
    init(id: UInt, avatar: UIImage?, name: String) {
        self.id = id
        self.avatar = avatar
        self.name = name
    }
}
