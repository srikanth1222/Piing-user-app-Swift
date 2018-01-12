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
    
    public static let latitude : CLLocationDegrees = 1.307924
    public static let longitude : CLLocationDegrees = 103.840963
    
    public static let MAIN_STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
    
    public static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    public static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    public static let ACCEPTABLE_CHARECTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.@"
    public static let VALIDATE_EMAILID = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    public static let IS_LOGIN_SUCCEDED = "Login_Succeded"
    
    public static let MAP_STYLE = "style"
    public static let MAP_STYLE_TYPE = "json"
    
    public static var GLOBAL_FONT_SIZE: CGFloat {
        
        get {
            
            //return AppDelegate.SCREEN_HEIGHT * 0.028
            
            return AppDelegate.SCREEN_WIDTH * 0.05
            
//            let height = UIScreen.main.bounds.size.height
//
//            if height == 480 || (height > 450 && height <= 480) {
//
//                return 14.0
//            }
//            else if height == 568 || (height > 540 && height <= 568) {
//
//                return 16.0
//            }
//            else if height == 667 || (height > 640 && height <= 667) {
//
//                return 18.0
//            }
//            else if height == 736 || (height > 700 && height <= 736) {
//
//                return 20.0
//            }
//            else if height == 812 || (height > 780 && height <= 812) {
//
//                return 19.0
//            }
//            else {
//
//                return 20.0
//            }
        }
    }
    
    public static var constantDictValues = Dictionary<String, Any>()
    
    public static func safeAreaTopInset() -> CGFloat {
        
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow!.safeAreaInsets.top
        }
        else {
           return 0
        }
    }
    
    public static func safeAreaBottomInset() -> CGFloat {
        
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        }
        else {
            return 0
        }
    }
    
    public static func safeAreaLeftInset() -> CGFloat {
        
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow!.safeAreaInsets.left
        }
        else {
            return 0
        }
    }
    
    public static func safeAreaRightInset() -> CGFloat {
        
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow!.safeAreaInsets.right
        }
        else {
            return 0
        }
    }
    
    public static func getAttributedString(_ string:String, spacing:Float) -> NSMutableAttributedString {
        
        let attrString = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, .font : UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-1)!, NSAttributedStringKey.kern: NSNumber(value: spacing)])
        return attrString
    }
    
    public static func getAddressDescription(_ addressModel: AddressModel) -> String {
        
        var strLaneAddr = ""
        
        if addressModel.line1!.count > 1 {
            
            strLaneAddr = addressModel.line1! + " "
        }
        if addressModel.line2!.count > 1 {
            
            strLaneAddr += addressModel.line2! + " "
        }
        
        strLaneAddr += addressModel.country! + " "
        strLaneAddr += addressModel.zipcode!
        
        return strLaneAddr
    }
    
    public static func validateEmail(_ email: String, with emailRegEx: String) -> Bool {
        
        let test = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return test.evaluate(with: email)
    }
    
    public static func showAlertViewWith(message: String, title: String, actionTitle:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        
        while ((topVC?.presentedViewController) != nil) {
            
            topVC = topVC?.presentedViewController
        }
        
        topVC?.present(alertController, animated: true, completion: nil)
    }
    
    public static func logoutFromTheApp() {
        
        UserDefaults.standard.set(false, forKey: AppDelegate.IS_LOGIN_SUCCEDED)
        
//        guard let loginNavVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "LoginNavViewController") as? UINavigationController else { return }
//        loginNavVC.isNavigationBarHidden = true
        
        guard let welcomeNavVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "NavWelcomeScreenViewController") as? UINavigationController else { return }
        welcomeNavVC.isNavigationBarHidden = true
        
        let appDel = UIApplication.shared.delegate
        
        appDel?.window??.rootViewController = welcomeNavVC
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey(googleApiKey())
        GMSPlacesClient.provideAPIKey(googleApiKey())
        
        if UserDefaults.standard.bool(forKey: AppDelegate.IS_LOGIN_SUCCEDED) == true {
            
            if UserDefaults.standard.object(forKey: "uid") != nil {
                AppDelegate.constantDictValues["uid"] = UserDefaults.standard.object(forKey: "uid")
                AppDelegate.constantDictValues["t"] = UserDefaults.standard.object(forKey: "token")
            }
            
            guard let homePageVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return true }
            
            let navVC = UINavigationController(rootViewController: homePageVC)
            navVC.isNavigationBarHidden = true
            
            window?.rootViewController = navVC
        }
        else {
            
            
        }
        
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

