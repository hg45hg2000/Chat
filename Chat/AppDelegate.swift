//
//  AppDelegate.swift
//  Chat
//
//  Created by HENRY on 2021/11/12.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications
import FirebaseMessaging
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        IQKeyboardManager.shared.enable = true
        apns(application: application)
        UserAPI.requestCurrentUserModel { userModel in
            
        }
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func apns(application: UIApplication){
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {

            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        }  
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
extension AppDelegate :  UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        if let tabBarController = UIApplication.shared.windows.first!.rootViewController               as? UITabBarController,
           let navController = tabBarController.selectedViewController as? UINavigationController,
           let chat = navController.topViewController as? ChatViewController
        {
            let friendModel = UserModel(dict: notification.request.content.userInfo as? Dictionary<String , Any> ?? ["":""] )
            // same room don't present notification
            if friendModel.roomId == chat.friendModel.roomId{return}
            completionHandler([.alert, .badge, .sound])
        }else{
            completionHandler([.alert, .badge, .sound])
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        let friendModel = UserModel(dict: response.notification.request.content.userInfo as? Dictionary<String , Any> ?? ["":""] )
        let aps = response.notification.request.content.userInfo["aps"] as! Dictionary <String,Any>
        let alert = aps["alert"] as! Dictionary <String,Any>
        let userDefaults = UserDefaults(suiteName: "group.chat.together")
        userDefaults?.set(alert["title"], forKey: "alertContent")
        userDefaults?.synchronize()
        UIViewController.APNSPushViewController(type: .Chat(friendModel))
        completionHandler()
    }
    
}
extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        UserModel.saveAPNSToken(token: fcmToken)
        MessageAPI.requestSaveApnsToken(token: fcmToken)
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // [END refresh_token]
}
