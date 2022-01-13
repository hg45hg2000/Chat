//
//  Message.swift
//  Chat
//
//  Created by HENRY on 2021/12/11.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Alamofire


// MARK: - Parameter
struct Parameter: Codable {
    let to, collapseKey: String
    let priority: Int
    let notification: NotificationData
    let data :NotificationModel?

    enum CodingKeys: String, CodingKey {
        case to
        case collapseKey = "collapse_key"
        case priority, notification,data
    }
}

// MARK: - DataClass
struct NotificationData: Codable {
    let body, title , sound, category : String
    let mutableContent : Bool
    let imageUrl : String?
    enum CodingKeys : String,CodingKey{
        case body,title,sound,imageUrl
        case category = "click_action"
        case mutableContent = "mutable_content"
    }
    init(body: String , title: String,imageUrl: String? = nil) {
        self.body = body
        self.title = title
        self.imageUrl = imageUrl
        sound = "default"
        category = "customPush"
        mutableContent = true
    }
}
//struct PostID:Codable{
//    let postID:String
//}
class MessageAPI{
    static func requestSaveApnsToken(token: String?){
        guard let uid = UserModel.getUid() else {return}
        let dict = ["token":token]
        Firestore.firestore().collection("users").document(uid).updateData(dict as [AnyHashable : Any])
    }
    static func requestDeleteApnsToken(){
        guard let uid = UserModel.getUid() else {return}
        let dict = ["token":""]
        Firestore.firestore().collection("users").document(uid).updateData(dict as [AnyHashable : Any])
    }
    static func requestSendAPNS(friendID: String,notification: NotificationData,targetUserModel:NotificationModel?){
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            guard error == nil else {return}
            for document in snapshot!.documents {
                let userModel = UserModel(dict: document.data())
                if userModel.friendId == friendID{
                    
                    requestSendApns(token: userModel.token, notification: notification, targetUserModel:targetUserModel)
                    break
                }
            }
        }
    }
    
    private static func requestSendApns(token: String?,notification: NotificationData,targetUserModel: NotificationModel?){
        let parameter = Parameter(to: token ?? "", collapseKey: "type_a", priority: 10, notification: notification, data:targetUserModel)
        let headers: HTTPHeaders = [
            "Authorization": "key=AAAA-okKnOQ:APA91bGOXIC79v4MIrKyovLR8968X0XYTWeR60tkl7vkeq8HKgF_r6VtzDdd4BvHIPuECIkAsr2Bh1fUkOcaMUtWAwpOg7Fs6oXZUaI5CsRpvtJxP1J7IVnjktAra1qF1VjyDi1VPYFh",
            "Content-Type": "application/json"
        ]
         AF.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: headers, interceptor: nil, requestModifier: nil).responseString { result in
            switch result.result{
            case.success(let string):
                print(string)
            case.failure(let error):
                print(error)
            }
        }
    
        
    }
}
