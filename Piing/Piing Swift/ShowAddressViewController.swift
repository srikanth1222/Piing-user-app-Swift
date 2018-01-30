//
//  ShowAddressViewController.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 13/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit
import GoogleMaps

protocol ShowAddressViewControllerDelegate: NSObjectProtocol {
    func doneAfterAddressSelectionPressedWith(pickupAddressModel: AddressModel, deliveryAddressModel: AddressModel)
}

class ShowAddressViewController: UIViewController, SelectAddressViewControllerDelegate {
    
    weak var delegate: ShowAddressViewControllerDelegate?
    
    private var customMapView: CustomMapView!
    
    @IBOutlet private weak var pickupAddressStackView: UIStackView!
    @IBOutlet private weak var deliveryAddressStackView: UIStackView!
    
    @IBOutlet private weak var pickupHeaderButton: UIButton!
    @IBOutlet private weak var pickupAddressName: UILabel!
    @IBOutlet private weak var pickupAddressDescription: UILabel!
    
    @IBOutlet private weak var deliveryHeaderButton: UIButton!
    @IBOutlet private weak var deliveryAddressName: UILabel!
    @IBOutlet private weak var deliveryAddressDescription: UILabel!
    
    @IBOutlet private weak var doneButton: UIButton!
    
    var orderSummeryObject = OrderSummeryModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print ("MaxY is:\(deliveryAddressStackView.frame.maxY)")
        
        customMapView = CustomMapView(frame: CGRect(x: 0.0, y: deliveryAddressStackView.frame.maxY, width: self.view.frame.size.width, height: doneButton.frame.minY-deliveryAddressStackView.frame.maxY))
        self.view.addSubview(customMapView)
        
        customMapView.mapView.padding = UIEdgeInsetsMake(30, 0, 0, 0)
        
        // Intialize Tap Gesture for Pickup Address Stack View
        let tapPickupGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnPickupAddressStackView))
        pickupAddressStackView.addGestureRecognizer(tapPickupGesture)
        
        // Intialize Tap Gesture for Delivery Address Stack View
        let tapDeliveryGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnDeliveryAddressStackView))
        deliveryAddressStackView.addGestureRecognizer(tapDeliveryGesture)
        
        
         // Set Pickup Header
        let attrKeyPickup = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-3)!, NSAttributedStringKey.kern: NSNumber(value: 2.0)]
        let attrPickup = NSAttributedString(string: "PICKUP", attributes: attrKeyPickup)
        
        pickupHeaderButton.setAttributedTitle(attrPickup, for: .normal)
        pickupHeaderButton.imageEdgeInsets = UIEdgeInsetsMake(pickupHeaderButton.frame.size.height * 0.3, -5, pickupHeaderButton.frame.size.height * 0.3, 0)
        pickupHeaderButton.imageView?.contentMode = .scaleAspectFit
        
        // Set Delivery Header
        let attrKeyDelivery = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-3)!, NSAttributedStringKey.kern: NSNumber(value: 2.0)]
        let attrDelivery = NSAttributedString(string: "DELIVERY", attributes: attrKeyDelivery)
        
        deliveryHeaderButton.setAttributedTitle(attrDelivery, for: .normal)
        deliveryHeaderButton.imageEdgeInsets = UIEdgeInsetsMake(deliveryHeaderButton.frame.size.height * 0.3, -5, deliveryHeaderButton.frame.size.height * 0.3, 0)
        deliveryHeaderButton.imageView?.contentMode = .scaleAspectFit
        
        if orderSummeryObject.selectedDeliveryAddressModel == nil {
            orderSummeryObject.selectedDeliveryAddressModel = orderSummeryObject.selectedPickupAddressModel
        }
        
        setupPickupAddress()
        
        setupDeliveryAddress()
        
        self.perform(#selector(updateMapView), with: nil, afterDelay: 0.7)
        
        // Set Done Button
        let attrKeyDone = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE)!, NSAttributedStringKey.kern: NSNumber(value: 2.0)]
        let attrDone = NSAttributedString(string: "DONE", attributes: attrKeyDone)
        
        doneButton.setAttributedTitle(attrDone, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.sendSubview(toBack: customMapView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        customMapView.frame = CGRect(x: 0.0, y: deliveryAddressStackView.frame.maxY + AppDelegate.safeAreaTopInset() + view.frame.size.height * 0.02, width: self.view.frame.size.width, height: doneButton.frame.minY - (deliveryAddressStackView.frame.maxY + AppDelegate.safeAreaTopInset() + view.frame.size.height * 0.02))
    }
    
    private func setupPickupAddress() {
        
        guard let addressModel = orderSummeryObject.selectedPickupAddressModel else { return }
        
        // Set Pickup Address Name
        let attrKeyPickupAddressName = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
        let attrPickupAddressName = NSAttributedString(string: addressModel.name!, attributes: attrKeyPickupAddressName)
        pickupAddressName.attributedText = attrPickupAddressName
        
        // Set Pickup Address Description
        let attrKeyPickupAddressDesc = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_REGULAR, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
        
        let strLaneAddr = AppDelegate.getAddressDescription(addressModel)
        
        // Set Pickup Address Description
        let attrPickupAddressDesc = NSAttributedString(string: strLaneAddr, attributes: attrKeyPickupAddressDesc)
        pickupAddressDescription.attributedText = attrPickupAddressDesc
        pickupAddressDescription.numberOfLines = 0
    }
    
    private func setupDeliveryAddress() {
        
        guard let addressModel = orderSummeryObject.selectedDeliveryAddressModel else { return }
        
        // Set Delivery Address Name
        let attrKeyDeliveryAddressName = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
        let attrDeliveryddressName = NSAttributedString(string: addressModel.name!, attributes: attrKeyDeliveryAddressName)
        deliveryAddressName.attributedText = attrDeliveryddressName
        
        let strLaneAddr = AppDelegate.getAddressDescription(addressModel)
        
        // Set Delivery Address Description
        let attrKeyDeliveryAddressDesc = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_REGULAR, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
        let attrDeliveryAddressDesc = NSAttributedString(string: strLaneAddr, attributes: attrKeyDeliveryAddressDesc)
        deliveryAddressDescription.attributedText = attrDeliveryAddressDesc
        deliveryAddressDescription.numberOfLines = 0
    }
    
    @objc private func tappedOnPickupAddressStackView() {
        
        print("Tapped on pickup address stack view")
        
        guard let selectAddressVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SelectAddressViewController") as? SelectAddressViewController else { return }
        selectAddressVC.addressType = .PICKUP
        selectAddressVC.addressModel = orderSummeryObject.selectedPickupAddressModel
        selectAddressVC.addressArray = orderSummeryObject.addressArray!
        selectAddressVC.delegate = self
        
        let navSelectAddrVC = UINavigationController(rootViewController: selectAddressVC)
        navSelectAddrVC.isNavigationBarHidden = true
        present(navSelectAddrVC, animated: true, completion: nil)
    }
    
    @objc private func tappedOnDeliveryAddressStackView() {
        
        print("Tapped on delivery address stack view")
        
        guard let selectAddressVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SelectAddressViewController") as? SelectAddressViewController else { return }
        selectAddressVC.addressType = .DELIVERY
        selectAddressVC.addressModel = orderSummeryObject.selectedDeliveryAddressModel
        selectAddressVC.addressArray = orderSummeryObject.addressArray!
        selectAddressVC.delegate = self
        
        let navSelectAddrVC = UINavigationController(rootViewController: selectAddressVC)
        navSelectAddrVC.isNavigationBarHidden = true
        present(navSelectAddrVC, animated: true, completion: nil)
    }
    
    @IBAction private func doneButtonPressed(_ sender: UIButton) {
        
        delegate?.doneAfterAddressSelectionPressedWith(pickupAddressModel: orderSummeryObject.selectedPickupAddressModel!, deliveryAddressModel: orderSummeryObject.selectedDeliveryAddressModel!)
        
        dismiss(animated: true, completion: nil)
    }
    
    func doneAfterAddressSelectionPressedWith(addressModel: AddressModel, addressType: AddressType) {
        
        if addressType.rawValue == "PICKUP" {
            orderSummeryObject.selectedPickupAddressModel = addressModel
            setupPickupAddress()
        }
        else if addressType.rawValue == "DELIVERY" {
            orderSummeryObject.selectedDeliveryAddressModel = addressModel
            setupDeliveryAddress()
        }
        else {
            
        }
        
        self.perform(#selector(updateMapView), with: nil, afterDelay: 0.7)
    }
    
    @objc private func updateMapView() {
        customMapView.clearAllMarkers()
        customMapView.showMultipleMarkersOnTheMap(with: orderSummeryObject.selectedPickupAddressModel!)
        customMapView.showMultipleMarkersOnTheMap(with: orderSummeryObject.selectedDeliveryAddressModel!)
        customMapView.focusMapToShowAllMarkers()
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
