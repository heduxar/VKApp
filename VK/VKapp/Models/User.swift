//
//  User.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class User: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var avatar: String = ""
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    let images = List<Photo>()
    let groups = List<Group>()
    
    convenience init(_ json: JSON, images: [Photo] = [], groups : [Group] = []) {
        self.init()
        self.id = json["id"].intValue
        self.avatar = json["photo_200_orig"].stringValue
        self.first_name = json["first_name"].stringValue
        self.last_name = json["last_name"].stringValue
        self.images.append(objectsIn: images)
        self.groups.append(objectsIn: groups)
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
