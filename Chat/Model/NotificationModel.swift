//
//  NotificationModel.swift
//  Chat
//
//  Created by HENRY on 2021/12/25.
//

import Foundation

class NotificationModel:UserModel{
    var imageUrl : String?
    
    override init(dict: Dictionary<String, Any>) {
        imageUrl = dict["imageUrl"] as? String
        super.init(dict: dict)
    }
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    enum CodingKeys: String, CodingKey {
        case imageUrl
    }
    
}
