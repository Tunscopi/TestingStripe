//
//  AppDelegate.swift
//  SeniorProject
//
//  Created by Jacari Boboye on 11/13/16.
//  Copyright © 2016 blah. All rights reserved.
//

import UIKit
import Stripe
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // do any other necessary launch configuration
        FIRApp.configure()

        let storyboard = UIStoryboard(name: "Main", bundle : nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.window?.rootViewController = loginVC
        
        return true
    }

}

