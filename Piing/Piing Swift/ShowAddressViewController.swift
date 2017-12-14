//
//  ShowAddressViewController.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 13/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit
import GoogleMaps

class ShowAddressViewController: UIViewController {
    
    var mapView: GMSMapView!
    
    @IBOutlet weak var pickupHeaderButton: UIButton!
    @IBOutlet weak var pickupAddressName: UILabel!
    @IBOutlet weak var pickupAddressDescription: UILabel!
    
    @IBOutlet weak var deliveryHeaderButton: UIButton!
    @IBOutlet weak var deliveryAddressName: UILabel!
    @IBOutlet weak var deliveryAddressDescription: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let camera = GMSCameraPosition.camera(withLatitude: AppDelegate.latitude, longitude: AppDelegate.longitude, zoom: 15.0, bearing: 270, viewingAngle: 0)
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height), camera: camera)
        view.addSubview(mapView)
        
         // Set Pickup Header
        let attrKeyPickup = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-3)!, NSAttributedStringKey.kern: NSNumber(value: 2.0)]
        let attrPickup = NSAttributedString(string: "PICKUP", attributes: attrKeyPickup)
        
        pickupHeaderButton.setAttributedTitle(attrPickup, for: .normal)
        pickupHeaderButton.imageEdgeInsets = UIEdgeInsetsMake(pickupHeaderButton.frame.size.height * 0.3, -5, pickupHeaderButton.frame.size.height * 0.3, 0)
        pickupHeaderButton.imageView?.contentMode = .scaleAspectFit
        
        // Set Pickup Address Name
        let attrKeyPickupAddressName = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
        let attrPickupAddressName = NSAttributedString(string: "HOME", attributes: attrKeyPickupAddressName)
        pickupAddressName.attributedText = attrPickupAddressName
        
        // Set Pickup Address Description
        let attrKeyPickupAddressDesc = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_REGULAR, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
        let attrPickupAddressDesc = NSAttributedString(string: "Cavenagh house, #09-04, 100 Clemenceau avenue, Singapore 229491", attributes: attrKeyPickupAddressDesc)
        pickupAddressDescription.attributedText = attrPickupAddressDesc
        
        
        // Set Delivery Header
        let attrKeyDelivery = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-3)!, NSAttributedStringKey.kern: NSNumber(value: 2.0)]
        let attrDelivery = NSAttributedString(string: "DELIVERY", attributes: attrKeyDelivery)
        
        deliveryHeaderButton.setAttributedTitle(attrDelivery, for: .normal)
        deliveryHeaderButton.imageEdgeInsets = UIEdgeInsetsMake(deliveryHeaderButton.frame.size.height * 0.3, -5, deliveryHeaderButton.frame.size.height * 0.3, 0)
        deliveryHeaderButton.imageView?.contentMode = .scaleAspectFit
        
        // Set Delivery Address Name
        let attrKeyDeliveryAddressName = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
        let attrDeliveryddressName = NSAttributedString(string: "WORK", attributes: attrKeyDeliveryAddressName)
        deliveryAddressName.attributedText = attrDeliveryddressName
        
        // Set Delivery Address Description
        let attrKeyDeliveryAddressDesc = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_REGULAR, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
        let attrDeliveryAddressDesc = NSAttributedString(string: "Cavenagh house, #09-04, 100 Clemenceau avenue, Singapore 229491", attributes: attrKeyDeliveryAddressDesc)
        deliveryAddressDescription.attributedText = attrDeliveryAddressDesc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.sendSubview(toBack: mapView)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
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
