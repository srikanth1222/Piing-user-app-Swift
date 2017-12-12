//
//  AppColors.swift
//  Piing user
//
//  Created by Veedepu Srikanth on 01/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit

class AppColors {
    
    public static let blueColor = UIColor(red: 29/255, green: 122/255, blue: 202/255, alpha: 1.0)
    
    public static func RGBColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor? {
        
        return UIColor(red: (r)/255, green: (g)/255, blue: (b)/255, alpha: (a))
    }
}

