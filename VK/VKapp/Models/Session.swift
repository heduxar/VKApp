//
//  Session.swift
//  VKapp
//
//  Created by Юрий Султанов on 10.08.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

class Session {
    public static let session = Session()
    var token: String?
    var userID: Int?
    var fireBaseUid: String?
    private init() {}
}
