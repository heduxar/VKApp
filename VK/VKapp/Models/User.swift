//
//  User.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import SwiftyJSON

class User {
    let id: Int
    let avatar: String
    let first_name: String
    let last_name: String
    init(_ json:JSON) {
        self.id = json["id"].intValue
        self.avatar = json["photo_200_orig"].stringValue
        self.first_name = json["first_name"].stringValue
        self.last_name = json["last_name"].stringValue
    }
}
