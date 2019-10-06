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
    @objc dynamic var type: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var avatarURL: String = ""
    @objc dynamic var newsText: String = ""
    var photoAttachments = List<Photo>()
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
        self.type = json["type"].stringValue
        self.newsText = json["text"].stringValue
        self.date = json["date"].doubleValue
        self.commentsCount = json["comments"]["count"].intValue
        self.likesCount = json["likes"]["count"].intValue
        self.userLike = json["likes"]["user_likes"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.views = json["views"]["count"].intValue
        
        let attachmentsJSONs = json["attachments"].arrayValue
        let photoAttachmentsJSONs = attachmentsJSONs.filter {$0["type"].stringValue == "photo"}
        photoAttachments.append (objectsIn: photoAttachmentsJSONs.map {Photo($0)})
    }
    override static func primaryKey() -> String? {
        return "sourceId"
    }
}
