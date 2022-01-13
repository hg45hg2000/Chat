//
//  UserModel.swift
//  Chat
//
//  Created by HENRY on 2021/11/16.
//

import Foundation
class UserModel:Codable{
    let email: String
    let uid: String
    let friendId : String
    var roomId : String?
    let token : String?
    init(roomId:String){
        email = ""
        uid = ""
        friendId = ""
        self.roomId = roomId
        token = ""
    }
    
    init(dict:Dictionary<String, Any>){
        email = dict["email"] as! String
        uid = dict["uid"] as! String
        friendId = dict["friendId"] as! String
        roomId = dict["roomId"] as? String
        token = dict["token"] as? String
    }
    func toDict()->Dictionary<String,Any>{
        return ["email":email,
                "uid":uid,
                "friendId":friendId,
                "roomId":roomId ?? "",
                "token":token ?? ""]
    }
    func saveToLocal(){
        UserModel.saveUserDict(dict: self.toDict())
    }
    
    static func saveUserDict(dict:Dictionary<String,Any>){
        UserDefaults.standard.set(dict, forKey: "userInfo")
    }
    
    
    static func initLocalData()->UserModel?{
        if let dict = UserDefaults.standard.object(forKey: "userInfo"){
            return UserModel(dict: dict as! Dictionary<String, Any>)
        }
        return nil
    }
    static func saveAPNSToken(token:String?){
        UserDefaults.standard.set(token, forKey: "token")
    }
    static func getAPNSToken()->String?{
        return UserDefaults.standard.object(forKey: "token") as? String
    }
    static func saveUid(uid:String?){
        UserDefaults.standard.set(uid, forKey: "uid")
    }
    static func getUid()->String?{
        return UserDefaults.standard.object(forKey: "uid") as? String
    }
    static func deleteUid(){
        UserDefaults.standard.removeObject(forKey: "uid")
    }
}
