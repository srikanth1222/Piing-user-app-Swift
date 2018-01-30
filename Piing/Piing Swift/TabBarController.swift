//
//  TabBarController.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 25/01/18.
//  Copyright © 2018 Piing. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = AppColors.RGBColor(r: 75, g: 155, b: 240, a: 1.0)
        
        //UITabBar.appearance().tintColor = UIColor.darkGray
        UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: AppFont.CALIBRI_BOLD, size: 10)!, NSAttributedStringKey.foregroundColor : AppColors.blueColor], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: AppFont.CALIBRI_BOLD, size: 10)!, NSAttributedStringKey.foregroundColor : UIColor.darkGray], for: .normal)
        
        let tabBarItems = self.tabBar.items!
        
        let tabBarImages_inActive = ["book_inactive", "mywashes_inactive", "pricing_inactive", "inbox_inactive", "more_inactive"]
        let tabBarImages_active = ["book_active", "mywashes_active", "pricing_active", "inbox_active", "more_active"]
        
        tabBarItems.forEach { (tabBarItem) in
            tabBarItem.image = UIImage(named: tabBarImages_inActive[tabBarItems.index(of: tabBarItem)!])?.withRenderingMode(.alwaysOriginal)
            tabBarItem.selectedImage = UIImage(named: tabBarImages_active[tabBarItems.index(of: tabBarItem)!])?.withRenderingMode(.alwaysOriginal)
            
            tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = AppDelegate.safeAreaBottomInset() + 56
        
        return sizeThatFits
    }
}



