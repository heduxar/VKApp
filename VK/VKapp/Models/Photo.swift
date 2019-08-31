//
//  Photo.swift
//  VKapp
//
//  Created by Юрий Султанов on 25.08.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var owner_id: Int = 0
    @objc dynamic var urlString: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var likes: Int = 0
    @objc dynamic var user_likes: Int = 0
    @objc dynamic var reposts: Int = 0
    
    convenience init (_ json:JSON){
        self.init()
        self.id = json["id"].intValue
        self.owner_id = json["owner_id"].intValue
        let sizes = json["sizes"].arrayValue
        let biggestSize = sizes.reduce(sizes[0]) {currentSize, newSize -> JSON in
            let currentPoints = currentSize["width"].intValue + currentSize["height"].intValue
            let newPoints = newSize["width"].intValue + newSize["height"].intValue
            return currentPoints >= newPoints ? currentSize : newSize
        }
        self.urlString = biggestSize["url"].stringValue
        self.text = json["text"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.user_likes = json["likes"]["user_likes"].intValue
        self.reposts = json["reposts"]["count"].intValue
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
