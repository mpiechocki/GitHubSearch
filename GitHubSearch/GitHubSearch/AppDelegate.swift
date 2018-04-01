//
//  AppDelegate.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
		
		NetworkActivityIndicatorManager.shared.isEnabled = true
		NetworkActivityIndicatorManager.shared.startDelay = 0.1
		
		window = UIWindow(frame: UIScreen.main.bounds)
		let initialViewController = ViewController()
		let navigationController = UINavigationController(rootViewController: initialViewController)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
		return true
	}
}

