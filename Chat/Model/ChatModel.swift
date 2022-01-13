//
//  ChatModel.swift
//  Chat
//
//  Created by HENRY on 2021/11/16.
//

import Foundation
import UIKit
import FirebaseStorage

enum ChatType{
    case text(String?)
    case image(StorageReference)
    init(dict:Dictionary<String, Any>){
        if let path = dict["image"] as? String{
            self = .image(FIStorage.sharedInstance.getRefPath(path: path))
        }else{
            self = .text(dict["text"] as? String)
        }
    }
}

struct ChatModel{
    let email : String
    let uid : String
    let type : ChatType
    let date : String
    init(dict:Dictionary<String, Any>){
        self.email = dict["email"] as! String
        self.uid = dict["uid"] as! String
        self.type = ChatType(dict: dict)
        self.date = dict["date"] as! String
    
    }
}


