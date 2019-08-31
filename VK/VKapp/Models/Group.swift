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

class Group: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var avatar: String = ""
    @objc dynamic var member: Int = 0
    convenience init(_ json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.avatar = json["photo_200"].stringValue
        self.member = json["is_member"].intValue
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
