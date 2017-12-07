//
//  SelectPickupDatesViewController.swift
//  Piing user
//
//  Created by Veedepu Srikanth on 04/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit
import Alamofire


class SelectPickupDatesViewController: UIViewController {

    @IBOutlet weak var tableViewDates: UITableView!
    @IBOutlet weak var tableViewTimeslots: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let dictPrams = ["uid" : "20316", "t" : "ttndot8lum", "pickupAddressId" : "20334", "serviceTypes" : "WI", "orderType" : "S"]
        
        let URLString = WebServices.BASE_URL+WebServices.GET_PICKUP_DATES_AND_TIMESLOTS
        
        WebServices.serviceCall(withURLString: URLString, parameters: dictPrams, completionHandler: {(error, responseObject, data) in
            
            guard let responseObject = responseObject else { return }
            
            //print (responseObject)
            
            
            
        })
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
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
