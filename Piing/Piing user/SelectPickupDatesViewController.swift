//
//  SelectPickupDatesViewController.swift
//  Piing user
//
//  Created by Veedepu Srikanth on 04/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit
import Alamofire


class SelectPickupDatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewDates: UITableView!
    @IBOutlet weak var tableViewTimeslots: UITableView!
    
    var pickupDates = ResponseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let dictPrams = ["uid" : "20316", "t" : "wun1aeu2ek", "pickupAddressId" : "20334", "serviceTypes" : "WI", "orderType" : "S"]
        
        let URLString = WebServices.BASE_URL+WebServices.GET_PICKUP_DATES_AND_TIMESLOTS
        
        WebServices.serviceCall(withURLString: URLString, parameters: dictPrams, completionHandler: {(error, responseObject, data) in
            
            guard let responseObject = responseObject else { return }
            
            print (responseObject)
            
            guard let data = data else { return }
            
            do {
                
                self.pickupDates = try JSONDecoder().decode(ResponseModel.self, from: data)
                
                //print(self.pickupDates)
            }
            catch let jsonDecodeErr {
                
                print(jsonDecodeErr)
            }
            
            
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableViewDates {
            return (self.pickupDates.dates?.count)!
        }
        
        else if tableView == tableViewTimeslots {
            
            guard let slots = self.pickupDates.dates else { return 0 }
            return slots.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "PICKUP_CELL"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil {
            
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellId)
            
        }
        
        return cell!
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
