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
    
    //MARK: FriendsAPI
    func getFriends(complition: @escaping ([User]) -> Void){
        let path = "/method/friends.get"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token" : token,
            "extended" : 1,
            "order" : "name",
            "name_case" : "nom",
            "fields": "photo_200",
            "v" : "5.101"
        ]
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let usersJSONs = json["response"]["items"].arrayValue
                let users = usersJSONs.map {User($0)}
                complition(users)
            case .failure(let err):
                print(err)
                complition([])
            }
        }
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
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let photosJSONs = json["response"]["items"].arrayValue
                let photos = photosJSONs.map {Photo($0)}
                complition(photos)
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
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let newLikes = json["response"]["likes"].intValue
                complition(newLikes)
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
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let newLikes = json["response"]["likes"].intValue
                complition(newLikes)
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
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let groupsJSONs = json["response"]["items"].arrayValue
                let groups = groupsJSONs.map {Group($0)}
                complition(groups)
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
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let joinJSON = json["response"].intValue
                complition(joinJSON)
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
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let leaveJSON = json["response"].intValue
                complition(leaveJSON)
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
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let groupsJSONs = json["response"]["items"].arrayValue
                let groups = groupsJSONs.map {Group($0)}
                complition(groups)
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
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let groupsJSONs = json["response"]["items"].arrayValue
                let groups = groupsJSONs.map {Group($0)}
                complition(groups)
            case .failure(let err):
                print(err)
                complition([])
            }
        }
    }
    
    //MARK: News
    func getNews(complition: @escaping ([News],[User],[Group]) -> Void){
        let path = "/method/newsfeed.get"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token": token,
            "filters" : "post",
            "count" : 20,
            "fields" : "photo_200",
            "v": "5.101"
        ]
        NetworkService.session.request(self.baseUrl + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                let newsDispatchGroup = DispatchGroup()
                var news = [News]()
                var groups = [Group]()
                var profiles = [User]()
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
                newsDispatchGroup.notify(queue: .main){
                    complition(news, profiles, groups)
                }
            case .failure(let err):
                print(err)
                complition([],[],[])
            }
        }
    }
    
}
