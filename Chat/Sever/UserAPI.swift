//
//  UserAPI.swift
//  Chat
//
//  Created by HENRY on 2021/12/3.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserAPI{
    static func freiendListCollection(_ collectionPath: String) -> CollectionReference{
        return        Firestore.firestore().collection("users").document(collectionPath).collection("friendList")
    }
    
    static func requestAddFriendAction(friendId:String ,completion:@escaping(_ Success:Bool)->Void){
        
        Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var userList = [UserModel]()
                var currentUserModel : UserModel?
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let user = UserModel(dict: document.data())
                    userList.append(user)
                    if user.uid == Auth.auth().currentUser?.uid{
                        currentUserModel = user
                    }
                   
                }
                guard currentUserModel?.friendId != friendId else {
                    return
                    
                }
                var Success = false
                for userModel in userList {
                    // find exist friend id
                    let roomId = String(Int.random(in:0...9999999999999999))
                    if userModel.friendId == friendId {
                        let dict = ["friendId":friendId,
                                    "email":userModel.email,
                                    "uid":userModel.uid,
                                    "roomId":roomId
                                    ] as [String : Any]
                        Firestore.firestore().collection("users").document(currentUserModel?.email ?? " ").updateData(["roomId":roomId])
                        freiendListCollection(Auth.auth().currentUser?.uid ?? " ").addDocument(data: dict)
                        let data = ["friendId":currentUserModel?.friendId,
                                    "email":currentUserModel?.email,
                                    "uid":currentUserModel?.uid,
                                    "roomId":roomId]
                        Firestore.firestore().collection("users").document(userModel.email).updateData(["roomId":roomId])
                        freiendListCollection(userModel.uid).addDocument(data: data)
                        Success = true
                        completion(Success)
                        break
                        }
                    }
                                                                                    
            if !Success{
                completion(Success)
                }
            }
        }
    }
    static func requestCheckFriendIdAvailable(friendId: String,completeion:@escaping(_ available:Bool)->Void){
        Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var available = false
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let user = UserModel(dict: document.data())
                    if user.friendId == friendId{
                        available = false
                        completeion(available)
                        break
                    }else{
                        available = true
                    }
                }
                if available{
                    completeion(available)
                }
            }
        }
    }
    static func requestCheckRegisted(_ uid: String,completeion:@escaping(_ Registed:Bool)->Void){
        Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var Registed = false
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let user = UserModel(dict: document.data())
                    if user.uid == uid{
                        Registed = true
                        completeion(Registed)
                        break
                    }else{
                        Registed = false
                    }
                }
                if !Registed{
                    completeion(Registed)
                }
            }
        }
    }
    
    static func requestCurrentUserModel(completeion:@escaping(_ userModel:UserModel)->Void){
        Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var friendList = [UserModel]()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let user = UserModel(dict: document.data())
                    friendList.append(user)
                    if user.uid == Auth.auth().currentUser?.uid{
                        user.saveToLocal()
                        completeion(user)
                    }
                }
            }
        }
    }
    static func requestFriendList(completeion:@escaping(_ friendList:[UserModel])->Void){
        freiendListCollection(Auth.auth().currentUser?.uid ?? " ").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var friendList = [UserModel]()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let user = UserModel(dict: document.data())
                    friendList.append(user)
                }
                completeion(friendList)
            }
        }

    }
}
