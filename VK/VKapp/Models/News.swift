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
    @objc dynamic var primaryKey: String = ""
    @objc dynamic var sourceId: Int = 0
    @objc dynamic var postId: Int = 0
    @objc dynamic var date: Double = 0
    @objc dynamic var type: String = ""
    @objc dynamic var newsText: String = ""
    var photoAttachments = List<Photo>()
    var videoAttachments = List<Video>()
    @objc dynamic var gifUrl: String = ""
    @objc dynamic var gifAspectRatio: Float = 0
    @objc dynamic var commentsCount: Int = 0
    @objc dynamic var likesCount: Int = 0
    @objc dynamic var userLike: Int = 0
    @objc dynamic var repostsCount: Int = 0
    @objc dynamic var views: Int = 0
    @objc dynamic var numberOfRows: Int = 0
    
    convenience init (_ json:JSON){
        self.init()
        var numberOfRows: Int = 2
        self.sourceId = json["source_id"].intValue
        self.postId = json["post_id"].intValue
        self.type = json["type"].stringValue
        if json["text"].stringValue != "" {
            self.newsText = json["text"].stringValue
            numberOfRows += 1
        }
        self.date = json["date"].doubleValue
        self.commentsCount = json["comments"]["count"].intValue
        self.likesCount = json["likes"]["count"].intValue
        self.userLike = json["likes"]["user_likes"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.views = json["views"]["count"].intValue
        self.primaryKey = json["source_id"].stringValue + "_" + json["date"].stringValue
        
        let attachmentsJSONs = json["attachments"].arrayValue
        let photoAttachmentsJSONs = attachmentsJSONs.filter {$0["type"].stringValue == "photo"}
        let gifAttachmentsJSON = attachmentsJSONs.filter {$0["doc"]["ext"].stringValue == "gif"}
        let videoAttachmentsJSONs = attachmentsJSONs.filter {$0["type"].stringValue == "video"}
        if photoAttachmentsJSONs.count != 0 {
            photoAttachments.append (objectsIn: photoAttachmentsJSONs.map {Photo($0)})
            numberOfRows += 1
        }
        if gifAttachmentsJSON.count > 0 {
            guard let gif = gifAttachmentsJSON.first else { return }
            self.gifUrl = gif["doc"]["url"].stringValue
            let aspectRatio = gif["doc"]["preview"]["video"]["height"].floatValue / gif["doc"]["preview"]["video"]["width"].floatValue
            self.gifAspectRatio = aspectRatio
            numberOfRows += 1
        }
        if videoAttachmentsJSONs.count > 0 {
            let networkService = NetworkService()
            var videoAttachments = [Video]()
            let dispatchGroup = DispatchGroup()
            DispatchQueue.global().async(group: dispatchGroup){
                videoAttachmentsJSONs.forEach { videoJSON in
                    networkService.getVideo(owner_id: videoJSON["video"]["owner_id"].intValue, id: videoJSON["video"]["id"].intValue, complition: { video in
                        guard let video = video.first else { return }
                        videoAttachments.append(video)
                    })
                }
            }
            dispatchGroup.notify(queue: .main) {
                self.videoAttachments.append(objectsIn: videoAttachments)
                numberOfRows += 1
            }
            print(videoAttachments)
        }
        
        self.numberOfRows = numberOfRows
    }
    override static func primaryKey() -> String? {
        return "primaryKey"
    }
}
