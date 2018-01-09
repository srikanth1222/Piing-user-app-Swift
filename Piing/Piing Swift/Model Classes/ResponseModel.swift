//
//  ResponseModel.swift
//  Piing user
//
//  Created by Veedepu Srikanth on 07/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import Foundation

struct ResponseModel: Decodable {
    
    var dates: [DateModel]?
    var addresses: [AddressModel]?
    var error: String?
    var s: Int?
    var address: ValidPostalCodeModel?
}

