//
//  AppDelegate.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CHMainViewController()
        window?.makeKeyAndVisible()

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {

        CHWebServiceManager.shared.suspendAll()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        CHWebServiceManager.shared.resumeAll()
    }

    func applicationWillTerminate(_ application: UIApplication) {

        CHWebServiceManager.shared.cancelAll()
    }
}

