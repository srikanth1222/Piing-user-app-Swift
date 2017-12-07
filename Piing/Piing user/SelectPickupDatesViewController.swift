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
    
    var selectedDateRow:Int = 0
    
    var pickupDates = ResponseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableViewDates.backgroundColor = AppColors.RGBColor(r: 238, g: 239, b: 243, a: 1.0)
        tableViewDates.separatorStyle = .none
        
        tableViewTimeslots.separatorStyle = .none
        
        let dictPrams = ["uid" : "20316", "t" : "wun1aeu2ek", "pickupAddressId" : "20334", "serviceTypes" : "WI", "orderType" : "S"]
        
        let URLString = WebServices.BASE_URL+WebServices.GET_PICKUP_DATES_AND_TIMESLOTS
        
        WebServices.serviceCall(withURLString: URLString, parameters: dictPrams, completionHandler: {(error, responseObject, data) in
            
            guard let responseObject = responseObject else { return }
            
            print (responseObject)
            
            guard let data = data else { return }
            
            do {
                
                self.pickupDates = try JSONDecoder().decode(ResponseModel.self, from: data)
                
                //print(self.pickupDates)
                
                self.tableViewDates.dataSource = self
                self.tableViewDates.delegate = self
                
                self.tableViewTimeslots.dataSource = self
                self.tableViewTimeslots.delegate = self
                
                self.tableViewDates.rowHeight = self.tableViewDates.frame.height * 0.11
                self.tableViewTimeslots.rowHeight = self.tableViewTimeslots.frame.height * 0.1
                
                self.tableViewDates.reloadData()
                self.tableViewTimeslots.reloadData()
            }
            catch let jsonDecodeErr {
                
                print("Error while parsing Pickup dates and timeslots: \(jsonDecodeErr)")
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableViewDates {
            
            return (self.pickupDates.dates?.count)!
        }
        else if tableView == tableViewTimeslots {
            
            guard let slots = self.pickupDates.dates![selectedDateRow].slots else { return 0 }
            return slots.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewDates {
            let cellId = "PICKUP_DATE_CELL"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
            
            if cell == nil {
                
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellId)
                
                let lblDate = UILabel()
                lblDate.frame = CGRect(x: 0, y: 0, width: tableViewDates.frame.size.width * 0.8, height: tableViewDates.rowHeight)
                lblDate.tag = 1
                lblDate.textColor = .gray
                lblDate.textAlignment = .center
                lblDate.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-1)
                cell?.contentView.addSubview(lblDate)
            }
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = AppColors.RGBColor(r: 230, g: 231, b: 235, a: 1.0)
            cell?.selectedBackgroundView = bgColorView
            
            cell?.backgroundColor = .clear
            
            let dateModel = self.pickupDates.dates![indexPath.row]
            guard let dateStr = dateModel.date else { return cell!}
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-mm-yyyy"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let date = dateFormatter.date(from: dateStr)
            
            dateFormatter.dateFormat = "dd MMM, EEE"
            let newDateStr = dateFormatter.string(from: date!)
            
            guard let lblDate = cell?.contentView.viewWithTag(1) as? UILabel else { return cell!}
            
            lblDate.text = newDateStr
            
            return cell!
        }
        else {
            
            let cellId = "PICKUP_TIMESLOT_CELL"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
            
            if cell == nil {
                
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellId)
                
                let lblTimeslot = UILabel()
                lblTimeslot.frame = CGRect(x: 0, y: 0, width: tableViewTimeslots.frame.size.width * 0.8, height: tableViewTimeslots.rowHeight)
                lblTimeslot.tag = 1
                lblTimeslot.textColor = .gray
                lblTimeslot.textAlignment = .center
                lblTimeslot.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-2)
                cell?.contentView.addSubview(lblTimeslot)
            }
            
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            
            let slotsModel = self.pickupDates.dates![selectedDateRow].slots![indexPath.row]
            
            guard let lblTimeslot = cell?.contentView.viewWithTag(1) as? UILabel else { return cell!}
            
            lblTimeslot.text = slotsModel.slot
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableViewDates {
            
            selectedDateRow = indexPath.row
            tableViewTimeslots.reloadData()
        }
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
