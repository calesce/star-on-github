//
//  AppDelegate.swift
//  star-on-github
//
//  Created by Cale Newman on 10/31/16.
//  Copyright © 2016 newman.cale. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var authenticated: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let token = UserDefaults.standard.string(forKey: ACCESS_TOKEN_KEY),
            let navController = storyboard.instantiateViewController(withIdentifier: "navRoot") as? UINavigationController,
            let starredRepositoriesVc = navController.viewControllers.first as? StarredRepositoriesViewController {
                starredRepositoriesVc.token = token
                starredRepositoriesVc.authorizationId = UserDefaults.standard.integer(forKey: AUTHORIZATION_ID_KEY)
            starredRepositoriesVc.isFirstViewController = true
            
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
        } else {
            let viewController = storyboard.instantiateViewController(withIdentifier: "login")
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

