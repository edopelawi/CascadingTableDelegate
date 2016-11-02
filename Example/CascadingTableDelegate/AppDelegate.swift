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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		let windowFrame = UIScreen.mainScreen().bounds
		window = UIWindow(frame: windowFrame)
		
		let welcomeViewController = WelcomeViewController()
		let rootNavController = UINavigationController(rootViewController: welcomeViewController)
		
		window?.rootViewController = rootNavController
		
		window?.makeKeyAndVisible()		
		
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
	
	}

    func applicationDidEnterBackground(application: UIApplication) {
		
    }

    func applicationWillEnterForeground(application: UIApplication) {
		
    }

    func applicationDidBecomeActive(application: UIApplication) {
		
    }

    func applicationWillTerminate(application: UIApplication) {
		
    }

}

