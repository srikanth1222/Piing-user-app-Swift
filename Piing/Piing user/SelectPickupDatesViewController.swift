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
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var tableViewDates: UITableView!
    @IBOutlet weak var tableViewTimeslots: UITableView!
    
    @IBOutlet weak var bottomDeliveryDateView: UIView!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var imageViewArrow: UIImageView!
    
    var selectedDateRow:Int = 0
    
    var pickupDates = ResponseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Intialize Tap Gesture for bottom date and time slot View
        let tapBottomDatesGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnBottomDatesView))
        bottomDeliveryDateView.addGestureRecognizer(tapBottomDatesGesture)
        
        
        let attrKeyDelivery = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-4)!, NSAttributedStringKey.kern: NSNumber(value: 0.7)]
        let attrDelivery = NSAttributedString(string: "DELIVERY DATE : TIME", attributes: attrKeyDelivery)
        
        lblDelivery.attributedText = attrDelivery
        lblDelivery.minimumScaleFactor = 0.5
        
        let image = UIImage.init(named: "right_icon")?.imageWithInsets(insetDimen: imageViewArrow.frame.size.width * 0.5)
        imageViewArrow.image = image
        
        centerView.backgroundColor =  AppColors.RGBColor(r: 238, g: 239, b: 243, a: 1.0)
        tableViewDates.backgroundColor = .clear
        tableViewDates.separatorStyle = .none
        
        tableViewTimeslots.backgroundColor = .white
        tableViewTimeslots.separatorStyle = .none
        
        var dictPrams = ["pickupAddressId" : "20334", "serviceTypes" : "WI", "orderType" : "S"]
        
        for(key, value) in AppDelegate.constantDictValues {
            dictPrams[key] = value
        }
        
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
                
                guard let dates = self.pickupDates.dates else { return }
                
                let heightDate = CGFloat(dates.count) * self.tableViewDates.rowHeight
                
                let customHeightDate = min(self.centerView.frame.size.height, heightDate)
                
                self.tableViewDates.frame = CGRect(x: self.tableViewDates.frame.origin.x, y: self.centerView.frame.size.height/2-customHeightDate/2, width: self.tableViewDates.frame.size.width, height: customHeightDate)
                
                
                
                guard let slots = dates[self.selectedDateRow].slots else { return }
                
                let height = CGFloat(slots.count) * self.tableViewTimeslots.rowHeight
                
                let customHeight = min(self.tableViewTimeslots.frame.size.height, height)
                
                self.tableViewTimeslots.frame = CGRect(x: self.tableViewTimeslots.frame.origin.x, y: self.centerView.frame.size.height/2-customHeight/2, width: self.tableViewTimeslots.frame.size.width, height: customHeight)
                
                
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableViewDates.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
            catch let jsonDecodeErr {
                
                print("Error while parsing Pickup dates and timeslots: \(jsonDecodeErr)")
            }
        })
    }
    
    @objc func tapOnBottomDatesView() {
        
        print("Tapped on Bottom Delivery date View")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableViewDates {
            
            guard let dates = self.pickupDates.dates else { return 0 }
            return dates.count
        }
        else if tableView == tableViewTimeslots {
            
            guard let dates = self.pickupDates.dates else { return 0 }
            guard let slots = dates[selectedDateRow].slots else { return 0 }
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
            
            guard let slots = self.pickupDates.dates?[selectedDateRow].slots else { return }
            
            let height = CGFloat(slots.count) * self.tableViewTimeslots.rowHeight
            
            let customHeight = min(self.centerView.frame.size.height, height)
            
            self.tableViewTimeslots.frame = CGRect(x: self.tableViewTimeslots.frame.origin.x, y: self.centerView.frame.size.height/2-customHeight/2, width: self.tableViewTimeslots.frame.size.width, height: customHeight)
            
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


extension UIImage {
    func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    
    func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            
            CGSize(width: self.size.width,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: 0, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
}



