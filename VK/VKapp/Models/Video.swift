//
//  Video.swift
//  VKapp
//
//  Created by Юрий Султанов on 31.10.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Video: Object {
    @objc dynamic var primaryKey: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var owner_id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var date: Double = 0
    @objc dynamic var comments: Int = 0
    @objc dynamic var views: Int = 0
    @objc dynamic var adding_date: Double = 0
    @objc dynamic var player: String = ""
    @objc dynamic var likes: Int = 0
    @objc dynamic var reposts: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var aspectRatio: Float = 0.75
    @objc dynamic var test: String = "" //Comment me
    
    convenience init(_ json: JSON){
        self.init()
        self.id = json["id"].intValue
        self.owner_id = json["owner_id"].intValue
        self.title = json["title"].stringValue
        self.date = json["date"].doubleValue
        self.comments = json["comments"].intValue
        self.views = json["views"].intValue
        self.adding_date = json["adding_date"].doubleValue
        self.player = json["player"].stringValue
        self.likes = json["likes"].intValue
        self.reposts = json["reposts"].intValue
        self.type = json["type"].stringValue
        self.primaryKey = json["owner_id"].stringValue + "_" + json["id"].stringValue
        var aspectRatio: Float {
            let height = json["height"].floatValue
            let width = json["width"].floatValue
            return height/width
        }
        self.aspectRatio = aspectRatio
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
