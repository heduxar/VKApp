//
//  User.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

struct User {
    let id: UInt
    var avatar: UIImage?
    var name: String
    var surname: String
    var images = [UIImage]()
    init(id: UInt, avatar: UIImage?, name: String, surname: String, images: [UIImage]) {
        self.id = id
        self.avatar = avatar
        self.name = name
        self.surname = surname
        self.images = images
    }
    init(id: UInt, avatar: UIImage?, name: String, surname: String) {
        self.id = id
        self.avatar = avatar
        self.name = name
        self.surname = surname
    }
}
