//
//  AppDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 08/01/2016.
//  Copyright (c) 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		let windowFrame = UIScreen.main.bounds
		window = UIWindow(frame: windowFrame)
		
		let welcomeViewController = WelcomeViewController()
		let rootNavController = UINavigationController(rootViewController: welcomeViewController)
		
		window?.rootViewController = rootNavController
		
		window?.makeKeyAndVisible()		
		
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
	
	}

    func applicationDidEnterBackground(_ application: UIApplication) {
		
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
		
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
		
    }

    func applicationWillTerminate(_ application: UIApplication) {
		
    }

}

