//
//  NetworkServices.swift
//  VKapp
//
//  Created by Юрий Султанов on 18.08.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import Foundation
import Alamofire

class NetworkServices {
    static let session: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 45
        config.waitsForConnectivity = true
        let session = SessionManager(configuration: config)
        return session
    }()
    
    func getGroups(){
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": "5.101"
        ]
        NetworkServices.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
    func getFriends(){
        let baseUrl = "https://api.vk.com"
        let path = "/method/friends.get"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token" : token,
            "extended" : 1,
            "order" : "name",
            "name_case" : "nom",
            "fields": "photo_200_orig",
            "v" : "5.101"
        ]
        NetworkServices.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
    func getPhotos(userId: Int){
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.get"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token" : token,
            "extended" : 1,
            "owner_id" : userId,
            "album_id" : "profile",
            "rev" : 0,
            "count" : 100,
            "v": "5.101"
        ]
        NetworkServices.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
    func searchGroups(searchText:String){
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.search"
        guard let token = Session.session.token else {preconditionFailure("Empty token!")}
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "q" : searchText,
            "sort" : 3,
            "v": "5.101"
        ]
        NetworkServices.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
}
