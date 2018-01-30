//
//  PaymentModel.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 17/01/18.
//  Copyright © 2018 Piing. All rights reserved.
//

import Foundation

struct PaymentModel: Decodable {
    
    var card: Card?
    var cash: Cash?
}

struct Card: Decodable {
    
    var available: Bool?
    var cardList: [CardList]?
    var `default`: Bool?
}

struct CardList: Decodable {
    
    var _id: String?
    var cardType: String?
    var cardTypeImage: String?
    var `default`: Bool?
    var expiryMonth: Int?
    var expiryYear: Int?
    var maskedCardNo: String?
    var uu_CardId: String?
}

struct Cash : Decodable {
    var available: Bool?
    var `default`: Bool?
}





