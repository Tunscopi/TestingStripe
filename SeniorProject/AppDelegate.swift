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
  
  // This method is where you handle URL opens if you are using a native scheme URLs (eg "yourexampleapp://")
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    let stripeHandled = Stripe.handleURLCallback(with: url)

    if (stripeHandled) {
      return true
    }
    else {
      // This was not a stripe url, do whatever url handling your app
      // normally does, if any.
    }
    
    return false
  }
  
  // This method is where you handle URL opens if you are using univeral link URLs (eg "https://example.com/stripe_ios_callback")
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
      if let url = userActivity.webpageURL {
        let stripeHandled = Stripe.handleURLCallback(with: url)
        
        if (stripeHandled) {
          return true
        }
        else {
          // This was not a stripe url, do whatever url handling your app
          // normally does, if any.
        }
      }
      
    }
    return false
  }

}

