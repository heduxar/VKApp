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
    @objc dynamic var avatar: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date = Date.distantPast
    @objc dynamic var newsText: String = "" {
        didSet {
            numberOfRows += 1
        }
    }
    var photos = List<Photo>() {
        didSet {
            numberOfRows += 1
        }
    }
    @objc dynamic var commentsCount: Int = 0
    @objc dynamic var likesCount: Int = 0
    @objc dynamic var userLike: Int = 0
    @objc dynamic var repostsCount: Int = 0
    @objc dynamic var views: Int = 0
    @objc dynamic var numberOfRows: Int = 2
    
    @objc dynamic lazy var primaryKeyValue: String = self.doublePrimaryKey()
    private func doublePrimaryKey() -> String {
        return "\(sourceId)_\(postId)"
    }
    
    convenience init (_ json:JSON){
        self.init()
        self.sourceId = json["items"]["source_id"].intValue
        self.postId = json["items"]["post_id"].intValue
        let date = json["items"]["date"].doubleValue
        self.date = Date(timeIntervalSince1970: date)
        self.commentsCount = json["items"]["comments"]["count"].intValue
        self.likesCount = json["items"]["likes"]["count"].intValue
        self.userLike = json["items"]["likes"]["user_likes"].intValue
        self.repostsCount = json["items"]["reposts"]["count"].intValue
        self.views = json["items"]["views"]["count"].intValue
//        self.id = json["id"].intValue
//        self.owner_id = json["owner_id"].intValue
//        let sizes = json["sizes"].arrayValue
//        let biggestSize = sizes.reduce(sizes[0]) {currentSize, newSize -> JSON in
//            let currentPoints = currentSize["width"].intValue + currentSize["height"].intValue
//            let newPoints = newSize["width"].intValue + newSize["height"].intValue
//            return currentPoints >= newPoints ? currentSize : newSize
//        }
//        self.urlSmallPhoto = sizes[0]["url"].stringValue
//        self.urlBigPhoto = biggestSize["url"].stringValue
//        self.text = json["text"].stringValue
//        self.likes = json["likes"]["count"].intValue
//        self.user_likes = json["likes"]["user_likes"].intValue
//        self.reposts = json["reposts"]["count"].intValue
    }
    override static func primaryKey() -> String? {
        return "primaryKeyValue"
    }
}
