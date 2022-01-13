//
//  UserDataManager.swift
//  Chat
//
//  Created by HENRY on 2021/12/5.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserDataManager{
    
    static let sharedInstance = UserDataManager()
    
    var currentUserModel : UserModel?
    
    init() {
        currentUserModel = UserModel.initLocalData()
    }
}
