//
//  OrderSummeryModel.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 17/01/18.
//  Copyright © 2018 Piing. All rights reserved.
//

import Foundation

struct OrderSummeryModel {
    
    var selectedPickupAddressModel: AddressModel?
    var selectedDeliveryAddressModel: AddressModel?
    
    var addressArray: [AddressModel]?
    var selectedPickupDate: String?
    var selectedPickupTimeSlot: String?
    var selectedDeliveryDate: String?
    var selectedDeliveryTimeSlot: String?
    var paymentData: PaymentModel?
    var orderSpeed: String?
    var orderType: String?
    
    var isSummeryLoaded: Bool = false
    
    var selectedServiceTypes : [String]?
}

