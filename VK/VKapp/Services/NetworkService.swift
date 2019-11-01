//
//  NetworkServices.swift
//  VKapp
//
//  Created by Юрий Султанов on 18.08.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class NetworkService {
    //MARK: TOP
    let baseUrl = "https://api.vk.com"
    static let session: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.waitsForConnectivity = true
        let session = SessionManager(configuration: config)
        return session
    }()
    
    //MARK: - VideoApi
    func getVideo(owner_id: Int? = nil, id: Int? = nil, complition: @escaping ([Video]) -> Void){
        let path = "/method/video.get"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        
        var params: Parameters = [
            "access_token" : token,
            "extended" : 1,
            "v" : "5.101"
        ]
        if let owner_id = owner_id {
            params.merge (["owner_id": String(owner_id)]) { (current, _) in current }
        }
        if let id = id,
            let owner_id = owner_id {
            params.merge (["videos": String(owner_id)+"_"+String(id)]) { (current, _) in current }
        }
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                var video = [Video]()
                let videoJSONs = json["response"]["items"].arrayValue
                video = videoJSONs.map {Video($0)}
                DispatchQueue.main.async {
                    complition(video)
                }
            case .failure(let err):
                print(err)
            }
        }
//            .responseJSON(queue: .global()) { response in
//                switch response.result {
//                case .success(let value):
//                    var groups = [Group]()
//                    let json = JSON(value)
//                    let groupsJSONs = json["response"]["items"].arrayValue
//                    groups = groupsJSONs.map {Group($0)}
//                    DispatchQueue.main.async {
//                        complition(groups)
//                    }
//                case .failure(let err):
//                    print(err)
//                    complition([])
//                }
    }
    
    //MARK: FriendsAPI
//    func getFriends(complition: @escaping ([User]) -> Void){
    func getFriends() -> Promise<[User]>{
        let path = "/method/friends.get"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        
        let params: Parameters = [
            "access_token" : token,
            "extended" : 1,
            "order" : "name",
            "name_case" : "nom",
            "fields": "photo_200, is_friend",
            "v" : "5.101"
        ]
        
        return NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params)
            .responseJSON()
            .map(on: .global()) { json, response in
                let json = JSON(json)

                if let errorMessage = json["error"]["error_msg"].string {
                    let error = VKError.someError(message: errorMessage)
                    throw error
                }

                let usersJSONs = json["response"]["items"].arrayValue
                return usersJSONs.map {User($0)}
        }
////        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                var users = [User]()
//                let usersJSONs = json["response"]["items"].arrayValue
//                users = usersJSONs.map {User($0)}
//                DispatchQueue.main.async {
//                    complition(users)
//                }
//            case .failure(let err):
//                print(err)
//                complition([])
//            }
//        }
    }
    
    //MARK: PhotoAPI
    func getPhotos(userId: Int, offset: Int = 0, complition: @escaping ([Photo]) -> Void){
        let path = "/method/photos.getAll"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token" : token,
            "scope" : "photos",
            "owner_id" : userId,
            "extended" : 1,
            "offset" : offset,
            "count" : 200,
            "photo_sizes" : 0,
            "no_service_albums" : 0,
            "need_hidden" : 0,
            "skip_hidden" : 1,
            "v": "5.101"
        ]
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var photos = [Photo]()
                let photosJSONs = json["response"]["items"].arrayValue
                photos = photosJSONs.map {Photo($0)}
                DispatchQueue.main.async {
                    complition(photos)
                }
            case .failure(let err):
                print(err)
                complition([])
            }
        }
    }
    
    //MARK: LikeAPI
    func likesAdd (ownerId: Int, itemId: Int, type: String, complition: @escaping (Int) -> Void){
        let path = "/method/likes.add"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token": token,
            "type" : type,
            "owner_id" : ownerId,
            "item_id" : itemId,
            "v": "5.101"
        ]
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let newLikes = json["response"]["likes"].intValue
                DispatchQueue.main.async {
                    complition(newLikes)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    func likesDelete (ownerId: Int, itemId: Int, type: String, complition: @escaping (Int) -> Void){
        let path = "/method/likes.delete"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token": token,
            "type" : type,
            "owner_id" : ownerId,
            "item_id" : itemId,
            "v": "5.101"
        ]
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let newLikes = json["response"]["likes"].intValue
                DispatchQueue.main.async {
                    complition(newLikes)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    //MARK: GroupsAPI
    func getGroups(complition: @escaping ([Group]) -> Void){
        let path = "/method/groups.get"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "count": 1000,
            "v": "5.101"
        ]
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                var groups = [Group]()
                let json = JSON(value)
                let groupsJSONs = json["response"]["items"].arrayValue
                groups = groupsJSONs.map {Group($0)}
                DispatchQueue.main.async {
                    complition(groups)
                }
            case .failure(let err):
                print(err)
                complition([])
            }
        }
    }
    
    func joinGroup(groupId: Int ,complition: @escaping (Int) -> Void){
        let path = "/method/groups.join"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token": token,
            "group_id": groupId,
            "v": "5.101"
        ]
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let joinJSON = json["response"].intValue
                DispatchQueue.main.async {
                    complition(joinJSON)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    func leaveGroup(groupId: Int ,complition: @escaping (Int) -> Void){
        let path = "/method/groups.leave"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token": token,
            "group_id": groupId,
            "v": "5.101"
        ]
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let leaveJSON = json["response"].intValue
                DispatchQueue.main.async {
                    complition(leaveJSON)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getCatalog(complition: @escaping ([Group]) -> Void){
        let path = "/method/groups.getCatalog"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token": token,
            "v": "5.101"
        ]
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                var groups = [Group]()
                let json = JSON(value)
                let groupsJSONs = json["response"]["items"].arrayValue
                groups = groupsJSONs.map {Group($0)}
                DispatchQueue.main.async {
                    complition(groups)
                }
            case .failure(let err):
                print(err)
                complition([])
            }
        }
    }
    
    func searchGroups(searchText:String, complition: @escaping ([Group]) -> Void){
        let path = "/method/groups.search"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "q" : searchText,
            "sort" : 3,
            "v": "5.101"
        ]
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                var groups = [Group]()
                let json = JSON(value)
                let groupsJSONs = json["response"]["items"].arrayValue
                groups = groupsJSONs.map {Group($0)}
                DispatchQueue.main.async {
                    complition(groups)
                }
            case .failure(let err):
                print(err)
                complition([])
            }
        }
    }
    
    //MARK: - News
    func getNews(startTime: Double? = nil, startFrom: String? = nil, complition: @escaping (Alamofire.Result<(news: [News], users: [User], groups: [Group], nextFrom: String)>) -> Void){
        let path = "/method/newsfeed.get"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        var params: Parameters = [
            "access_token": token,
            "filters" : "post",
            "count" : 10,
            "fields" : "photo_200, is_friend",
            "v": "5.101"
        ]
        if let startTime = startTime {
            params.merge(["start_time": String(startTime)]) { (current, _) in current }
        }
        if let startFrom = startFrom {
            params.merge(["start_from": startFrom])  { (current, _) in current }
        }
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                let newsDispatchGroup = DispatchGroup()
                var news = [News]()
                var groups = [Group]()
                var profiles = [User]()
                var nextFrom: String = ""
                let json = JSON(value)
                DispatchQueue.global().async(group: newsDispatchGroup){
                    let newsJSONs = json["response"]["items"].arrayValue
                    news = newsJSONs.map {News($0)}
                }
                DispatchQueue.global().async(group: newsDispatchGroup){
                    let groupsJSONs = json["response"]["groups"].arrayValue
                    groups = groupsJSONs.map {Group($0)}
                }
                DispatchQueue.global().async(group: newsDispatchGroup) {
                    let profilesJSONs = json["response"]["profiles"].arrayValue
                    profiles = profilesJSONs.map {User($0)}
                }
                DispatchQueue.global().async {
                    nextFrom = json["response"]["next_from"].stringValue
                }
                newsDispatchGroup.notify(queue: .main){
                    let result = Alamofire.Result<(news: [News], users: [User], groups: [Group], nextFrom: String)>.success((news, profiles, groups, nextFrom))
                    complition (result)
                }
            case .failure(let error):
                print(error)
                let result = Alamofire.Result<(news: [News], users: [User], groups: [Group], nextFrom: String)>.failure(error)
                complition(result)
            }
        }
    }
    
}
