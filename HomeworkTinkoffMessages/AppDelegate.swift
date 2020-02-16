//
//  AppDelegate.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 13.02.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("Application moved from Not running to Inactive: application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)")
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

