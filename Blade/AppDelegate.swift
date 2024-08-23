//
//  AppDelegate.swift
//  Blade
//
//  Created by cqlsys on 07/10/22.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GooglePlaces


import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return UIInterfaceOrientationMask.portrait
        }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        GMSPlacesClient.provideAPIKey("AIzaSyChu793aX7fFjQ1C95K7mQqfh0CgwrD81c")
        application.applicationIconBadgeNumber = 0
        LocationManager.sharedInstance.determineMyCurrentLocation()
//        for family in UIFont.familyNames {
//            print("\(family)")
//
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print("   \(name)")
//            }
//        }
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            //Messaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // Override point for customization after application launch.
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Blade")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate,MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "Firebase_Token")
//      let dataDict:[String: String] = ["token": fcmToken]
//      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    //MARK: - UIApplicationDelegate Methods
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        
        // Print message ID.
        //    if let messageID = userInfo[gcmMessageIDKey]
        //    {
        //      print("Message ID: \(messageID)")
        //    }
        
        // Print full message.
        print(userInfo)
        
        //    let code = String.getString(message: userInfo["code"])
//        guard let aps = userInfo["aps"] as? Dictionary<String, Any> else { return }
//        guard let alert = aps["alert"] as? String else { return }
        //    guard let body = alert["body"] as? String else { return }
        
        completionHandler([.alert,.sound])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
//        if UserPreference.shared.data?.auth_key != nil {
//            if let dict = userInfo as? [String : Any]{
//                if let textString = dict["gcm.notification.type"] as? String{
//                    
//                    
//                    if let tabBarController  = rootController1 as? Tabbar , let navController = tabBarController.selectedViewController as? UINavigationController ,  let visibleViewController = navController.visibleViewController {
//                        
//                        let story = UIStoryboard.init(name: "Home", bundle: nil)
//                        
//                        if let data = (dict["body"] as? String)?.data(using: .utf8) {
//                            do {
//                                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
//                                
//                                if let jsonObject = json?["data"] as? [String: Any] {
//                                    if let jsonData = jsonObject["id"] as? Int {
//                                        if textString == "1999" {
//                                            let vw = story.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
//                                            vw.wineId = jsonData
//                                            navController.pushViewController(vw, animated: true)
//                                        } else {
//                                            let vw = story.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
//                                            vw.eventId = "\(jsonData)"
//                                            navController.pushViewController(vw, animated: true)
//                                        }
//                                    }
//                                }
//                                
//                                
//                            } catch {
//                                print("Something went wrong")
//                            }
//                        }
//                    }
//                }
//            }
//        }
        completionHandler()
    }
}
