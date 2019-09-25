//
//  TableViewCell.swift
//  VKapp
//
//  Created by Юрий Султанов on 26.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class News: Object {
    @objc dynamic var sourceId: Int = 0
    @objc dynamic var postId: Int = 0
    @objc dynamic var date: Double = 0
//    @objc dynamic var type: String = ""
    @objc dynamic var newsText: String = ""
//    var attachment = List<Photo>() {
//        didSet {
//            numberOfRows += 1
//        }
//    }
    @objc dynamic var commentsCount: Int = 0
    @objc dynamic var likesCount: Int = 0
    @objc dynamic var userLike: Int = 0
    @objc dynamic var repostsCount: Int = 0
    @objc dynamic var views: Int = 0
    @objc dynamic var numberOfRows: Int = 3
    
    convenience init (_ json:JSON){
        self.init()
        self.sourceId = json["source_id"].intValue
        self.postId = json["post_id"].intValue
//        self.type = json["type"].stringValue
        self.newsText = json["text"].stringValue
        self.date = json["date"].doubleValue
        self.commentsCount = json["comments"]["count"].intValue
        self.likesCount = json["likes"]["count"].intValue
        self.userLike = json["likes"]["user_likes"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.views = json["views"]["count"].intValue

        
        
//        self.id = json["id"].intValue
//        self.owner_id = json["owner_id"].intValue
//        let sizes = json["sizes"].arrayValue
//        let biggestSize = sizes.reduce(sizes[0]) {currentSize, newSize -> JSON in
//            let currentPoints = currentSize["width"].intValue + currentSize["height"].intValue
//            let newPoints = newSize["width"].intValue + newSize["height"].intValue
//            return currentPoints >= newPoints ? currentSize : newSize
//        }
    }
    override static func primaryKey() -> String? {
        return "sourceId"
    }
}
