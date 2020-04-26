//
//  AppDelegate.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 13.02.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.window = EmitterWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let conversationListVC = storyboard.instantiateViewController(identifier: "navConversationList")
            window?.rootViewController = conversationListVC
            window?.makeKeyAndVisible()
        } else {
            // Fallback on earlier versions
        }
        StorageManager(coreDataStack: NestedWorkersCoreDataStack.shared).getProfile(completion: { (profile) in
            print("Initial user from CoreDataStack: \(profile)")
        })
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("Application moved from Active to Inactive: applicationWillResignActive")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Application moved from Inactive to Active: applicationDidBecomeActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application moved from Inactive to Background: applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Application moved from Background to Inactive: applicationWillEnterForeground")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("Application moved from Background to Not Running: applicationWillTerminate")
    }

}
