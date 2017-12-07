//
//  DateModel.swift
//  Piing user
//
//  Created by Veedepu Srikanth on 07/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import Foundation

struct DateModel: Decodable {
    
    var date:String?
    var cl: Bool?
    var dis:Float?
    var slots:[Slots]?
}


struct Slots: Decodable {
    
    var cl: Bool?
    var dis:String?
    var id:Int?
    var slot:String?
}
