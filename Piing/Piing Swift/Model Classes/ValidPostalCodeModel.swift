//
//  ValidPostalCodeModel.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 02/01/18.
//  Copyright © 2018 Piing. All rights reserved.
//

import Foundation

struct ValidPostalCodeModel: Decodable {
    
    var building: String?
    var country: String?
    var lat: String?
    var lon: String?
    var region: String?
    var service_Applicable: String?
    var street: String?
    var zipcode: String?
}
