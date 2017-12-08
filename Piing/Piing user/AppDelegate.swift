//
//  AppDelegate.swift
//  Piing user
//
//  Created by Veedepu Srikanth on 05/09/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

func googleApiKey () -> String {
    
    return "AIzaSyCkEccrUP7nIe5QMqnjPVsspcuOnOegc2o"
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    public static var GLOBAL_FONT_SIZE: CGFloat {
        
        get {
            
            let height = UIScreen.main.bounds.size.height
            
            if height == 480 || (height > 450 && height <= 480) {
                
                return 14.0
            }
            else if height == 568 || (height > 540 && height <= 568) {
                
                return 16.0
            }
            else if height == 667 || (height > 640 && height <= 667) {
                
                return 18.0
            }
            else if height == 736 || (height > 700 && height <= 736) {
                
                return 20.0
            }
            else if height == 812 || (height > 780 && height <= 812) {
                
                return 19.0
            }
            else {
                
                return 20.0
            }
        }
    }
    
    public static let constantDictValues = ["uid" : "20316", "t" : "i28vw6uoel"]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey(googleApiKey())
        GMSPlacesClient.provideAPIKey(googleApiKey())
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

