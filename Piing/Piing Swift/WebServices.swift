//
//  WebServices.swift
//  Piing user
//
//  Created by Veedepu Srikanth on 05/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import Foundation


struct WebServices {
    
    // PRODUCTION URLS
//    public static let BASE_URL = "http://api.piing.com.sg:14161/api/"
//    public static let BASE_TRACKING_URL = "http://api.piing.com.sg:14161"
    
    
    // STAGING URLS
    public static let BASE_URL = "http://api.piing.in:14161/api/"
    public static let BASE_TRACKING_URL = "http://api.piing.com.in:14161"
    
    
    public static let REGISTER_SERVICE = "user/register"
    public static let LOGIN_SERVICE = "user/login"
    public static let GET_PICKUP_DATES_AND_TIMESLOTS = "order/pickupdates"
    public static let GET_DELIVERY_DATES_AND_TIMESLOTS = "order/deliverydates"
    public static let GET_ADDRESS = "address/get"
    public static let POSTALCODE_SERVICEABLE = "address/serviceable"
    
    public static func serviceCall (withURLString urlString:String, parameters: [String : Any], completionHandler: @escaping (Error?, Any?, Data?) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        var urlReq = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 50)
        urlReq.httpMethod = "POST"
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlReq.httpBody = data
        }
        catch let jsonErr {
            print (jsonErr)
        }
        
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            
            if error == nil {
                
                guard let data = data else { return }
                
                do {
                    let responsObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    DispatchQueue.main.async {
                        completionHandler(error, responsObject, data)
                    }
                }
                catch let jsonErr {
                    print(jsonErr)
                }
            }
            else {
                
                print(error!)
            }
        }.resume()
    }
}

