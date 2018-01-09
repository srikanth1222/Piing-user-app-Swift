//
//  LoginModel.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 22/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import Foundation

struct LoginModel: Decodable {
    
    var phone: String?
    var s: Int?
    var t: String?
    var uid: String?
    var verified: Bool?
    var r: LoginInnerModel?
    var error: String?
}


struct LoginInnerModel: Decodable {
    
    var bagCleaning: String?
    var bagStartPrice: Double?
    var clipHangerPrice: String?
    var curtainCleaning: String?
    var foldPrice: String?
    var freeWashDiscount: Double?
    var greenDryCleaningPercentage: Double?
    var isTourist: Bool?
    var pendingOrder: Bool?
    var pendingOrderId: Int?
    var recDiscount: Double?
    var recDiscountType: String?
    var refCode: String?
    var refMessage: String?
    var shoeCleaning: String?
    var shoePolishing: String?
    var shoeStartingPrice: Double?
    var userType: String?
}


