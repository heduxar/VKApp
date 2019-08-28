//
//  Group.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Group {
    @objc dynamic let id: Int
    @objc dynamic let name: String
    @objc dynamic let avatar: String
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.avatar = json["photo_200"].stringValue
    }
}
