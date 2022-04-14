//
//  AppDelegate.swift
//  CrossfadePlayer
//
//  Created by Admin on 05.04.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Going to inactive")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Going to foreground")
    }

}

