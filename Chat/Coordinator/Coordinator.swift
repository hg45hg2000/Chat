//
//  Coordinator.swift
//  Chat
//
//  Created by HENRY on 2021/12/5.
//

import Foundation
import UIKit
import FirebaseAuth
enum ViewControllerType{
    case Chat(UserModel)
}

extension UIViewController {
    
    static func mainStoryBoard()->UIStoryboard{
        return UIStoryboard.init(name: "Main", bundle: Bundle.main)
    }
    func checkLoginFlow(_ animated: Bool = true){
        guard let _ =  UserModel.getUid() else {
            let loginNav = UIViewController.mainStoryBoard().instantiateViewController(withIdentifier: "LoginNav")
            loginNav.modalPresentationStyle = .fullScreen
            loginNav.isModalInPresentation = true
            present(loginNav, animated: animated, completion: nil)
            return
        }
    }
    static func APNSPushViewController(type:ViewControllerType){
        if  let conversationVC = mainStoryBoard().instantiateViewController(withIdentifier: "Chat") as? ChatViewController,
                let tabBarController = UIApplication.shared.windows.first!.rootViewController as? UITabBarController,
                let navController = tabBarController.selectedViewController as? UINavigationController
        {
            switch type {
            case .Chat(let userModel):
                if let chat = navController.topViewController as? ChatViewController{
                    chat.friendModel = userModel
                    navController.popViewController(animated: false)
                    
                }
                    conversationVC.friendModel = userModel
                    navController.pushViewController(conversationVC, animated: false)
            }
        }
    }
}
