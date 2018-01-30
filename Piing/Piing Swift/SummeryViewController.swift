//
//  SummeryViewController.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 13/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit

class SummeryViewController: UIViewController, ShowAddressViewControllerDelegate {
    
    @IBOutlet private weak var scrollViewAllViews: UIScrollView!
    
    @IBOutlet private weak var addressView: UIView!
    
    @IBOutlet private weak var deliveryAddressStackView: UIStackView! {
        
        didSet {
            // Intialize Tap Gesture for Delivery Address Stack View
            let tapDeliveryGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnDeliveryAddressStackView))
            deliveryAddressStackView.addGestureRecognizer(tapDeliveryGesture)
        }
    }
    
    @IBOutlet private weak var pickupAddressStackView: UIStackView! {
        
        didSet {
            // Intialize Tap Gesture for Pickup Address Stack View
            let tapPickupGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnPickupAddressStackView))
            pickupAddressStackView.addGestureRecognizer(tapPickupGesture)
        }
    }
    
    @IBOutlet private weak var addressViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var lblPickupAddress: UILabel!
    @IBOutlet private weak var lblPickupLaneAddress: UILabel!
    
    @IBOutlet private weak var lblDeliveryAddress: UILabel!
    @IBOutlet private weak var lblDeliveryLaneAddress: UILabel!
    
    @IBOutlet private weak var servicesView: UIView! {
        didSet {
            servicesView.layer.cornerRadius = AppDelegate.SCREEN_WIDTH * 0.04
        }
    }
    
    @IBOutlet private weak var datesView: UIView! {
        didSet {
            datesView.layer.cornerRadius = AppDelegate.SCREEN_WIDTH * 0.04
        }
    }
    
    @IBOutlet private weak var orderTypeView: UIView! {
        didSet {
            orderTypeView.layer.cornerRadius = AppDelegate.SCREEN_WIDTH * 0.04
        }
    }
    
    @IBOutlet private weak var pickupDateStackView: UIStackView! {
        
        didSet {
            // Intialize Tap Gesture for Pickup Address Stack View
            let tapPickupGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnPickupDateStackView))
            pickupDateStackView.addGestureRecognizer(tapPickupGesture)
        }
    }
    
    @IBOutlet private weak var deliveryDateStackView: UIStackView! {
        
        didSet {
            // Intialize Tap Gesture for Pickup Address Stack View
            let tapDeliveryGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnDeliveryDateStackView))
            deliveryDateStackView.addGestureRecognizer(tapDeliveryGesture)
        }
    }
    
    @IBOutlet private weak var upArrowIcon: UIImageView!
    @IBOutlet private weak var downArrowIcon: UIImageView!
    
    @IBOutlet private weak var lblPickupTitle: UILabel!
    @IBOutlet private weak var lblPickupDate: UILabel!
    @IBOutlet private weak var lblPickupTimeSlot: UILabel!
    
    @IBOutlet private weak var lblDeliveryTitle: UILabel!
    @IBOutlet private weak var lblDeliveryDate: UILabel!
    @IBOutlet private weak var lblDeliveryTimeSlot: UILabel!
    
    @IBOutlet private weak var onceButton: UIButton! {
        didSet {
            onceButton.titleLabel?.font = UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-6)
        }
    }
    
    @IBOutlet private weak var recurringButton: UIButton! {
        didSet {
            recurringButton.titleLabel?.font = UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-6)
        }
    }
    
    @IBOutlet private weak var lblPayment: UILabel! {
        didSet {
            let attrKeyPayment = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 1.2)]
            let attrPayment = NSAttributedString(string: "VISA 1234", attributes: attrKeyPayment)
            
            lblPayment.attributedText = attrPayment
        }
    }
    
    @IBOutlet private weak var lblCoupon: UILabel! {
        didSet {
            let attrKeyCoupon = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 1.2)]
            let attrCoupon = NSAttributedString(string: "COUPON", attributes: attrKeyCoupon)
            
            lblCoupon.attributedText = attrCoupon
        }
    }
    
    @IBOutlet private weak var lblPreferences: UILabel! {
        didSet {
            let attrKeyPrefs = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 1.2)]
            let attrPrefs = NSAttributedString(string: "PREFERENCES", attributes: attrKeyPrefs)
            
            lblPreferences.attributedText = attrPrefs
        }
    }
    
    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            let attrKeySubmit = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-2)!, NSAttributedStringKey.kern: NSNumber(value: 2.0)]
            let attrSubmit = NSAttributedString(string: "PIING!", attributes: attrKeySubmit)
            
            submitButton.setAttributedTitle(attrSubmit, for: .normal)
        }
    }
    
    var orderSummeryObject = OrderSummeryModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onceButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6)
        onceButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        recurringButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8)
        recurringButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0)
        recurringButton.backgroundColor = .clear
        
        onceButton.layer.cornerRadius = AppDelegate.SCREEN_WIDTH * 0.045
        recurringButton.layer.cornerRadius = AppDelegate.SCREEN_WIDTH * 0.045
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupPickupAddress()
        setupPickupAndDeliveryDateTimeSlots()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print("Content size is \(scrollViewAllViews.contentSize)")
    }
    
    @objc private func tappedOnPickupAddressStackView()
    {
        print("Tapped on pickup address stack view")
        
        guard let showAddress = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "ShowAddressViewController") as? ShowAddressViewController else { return }
        showAddress.orderSummeryObject = orderSummeryObject
        showAddress.delegate = self
        
        let navShowAddrVC = UINavigationController(rootViewController: showAddress)
        navShowAddrVC.isNavigationBarHidden = true
        present(navShowAddrVC, animated: true, completion: nil)
    }
    
    @objc private func tappedOnDeliveryAddressStackView()
    {
        print("Tapped on delivery address stack view")
        
        guard let showAddress = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "ShowAddressViewController") as? ShowAddressViewController else { return }
        showAddress.orderSummeryObject = orderSummeryObject
        showAddress.delegate = self
        
        let navShowAddrVC = UINavigationController(rootViewController: showAddress)
        navShowAddrVC.isNavigationBarHidden = true
        present(navShowAddrVC, animated: true, completion: nil)
    }
    
    @objc private func tappedOnPickupDateStackView() {
        guard let selectPickupDatesVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SelectPickupDatesViewController") as? SelectPickupDatesViewController else { return }
        selectPickupDatesVC.orderSummeryObject = orderSummeryObject
        
        let navPickupVC = UINavigationController(rootViewController: selectPickupDatesVC)
        navPickupVC.isNavigationBarHidden = true
        present(navPickupVC, animated: true, completion: nil)
    }
    
    @objc private func tappedOnDeliveryDateStackView() {
        guard let selectPickupDatesVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SelectPickupDatesViewController") as? SelectPickupDatesViewController else { return }
        selectPickupDatesVC.orderSummeryObject = orderSummeryObject
        
        let navPickupVC = UINavigationController(rootViewController: selectPickupDatesVC)
        navPickupVC.isNavigationBarHidden = true
        present(navPickupVC, animated: false) {
            
            guard let selectDeliveryDatesVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SelectDeliveryDatesViewController") as? SelectDeliveryDatesViewController else { return }
            selectDeliveryDatesVC.orderSummeryObject = self.orderSummeryObject
            
            navPickupVC.pushViewController(selectDeliveryDatesVC, animated: true)
        }
    }
    
    private func adjustAddressViewHeight() {
        if orderSummeryObject.selectedPickupAddressModel?._id == orderSummeryObject.selectedDeliveryAddressModel?._id {
            self.addressViewBottomConstraint.constant = -self.deliveryAddressStackView.frame.size.height
        }
        else {
            self.addressViewBottomConstraint.constant = 0
        }
    }
    
    private func setupPickupAddress() {
        
        adjustAddressViewHeight()
        
        upArrowIcon.isHidden = false
        downArrowIcon.isHidden = false
        
        deliveryAddressStackView.isHidden = true
        
        let strPickupAddrText = "PICKUP"
        
        guard var strIsHome = orderSummeryObject.selectedPickupAddressModel?.name else { return }
        
        strIsHome = "  @ " + strIsHome.uppercased()
        
        var strLaneAddr = AppDelegate.getAddressDescription(orderSummeryObject.selectedPickupAddressModel!)
        
        strLaneAddr = strLaneAddr.lowercased().capitalizingFirstLetter()
        
        let attrKeyPickupAddrText = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 2.5)]
        
        let attrKeyDeliveryAddrText = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 2.5)]
        
        let attrKeyIsHome = [NSAttributedStringKey.foregroundColor : UIColor.gray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.7)]
        
        let attrKeyLaneAddr = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 1.2)]
        
        let attrPickupAddrText = NSMutableAttributedString(string: strPickupAddrText, attributes: attrKeyPickupAddrText)
        
        if orderSummeryObject.selectedPickupAddressModel?._id == orderSummeryObject.selectedDeliveryAddressModel?._id {
            
            let strSeparator = " |  "
            let strDeliveryAddrText = "DELIVERY"
            
            let attrKeySeparator = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-6)!]
            
            let attrSeparator = NSMutableAttributedString(string: strSeparator, attributes: attrKeySeparator)
            let attrDeliveryAddrText = NSMutableAttributedString(string: strDeliveryAddrText, attributes: attrKeyDeliveryAddrText)
            
            attrPickupAddrText.append(attrSeparator)
            attrPickupAddrText.append(attrDeliveryAddrText)
        }
        else {
            setupDeliveryAddress()
        }
        
        let attrIsHome = NSMutableAttributedString(string: strIsHome, attributes: attrKeyIsHome)
        let attrLaneAddr = NSMutableAttributedString(string: strLaneAddr, attributes: attrKeyLaneAddr)
        
        attrPickupAddrText.append(attrIsHome)
        
        lblPickupAddress.attributedText = attrPickupAddrText
        lblPickupLaneAddress.attributedText = attrLaneAddr
        //lblPickupLaneAddress.backgroundColor = .red
    }
    
    private func setupDeliveryAddress() {
        
        upArrowIcon.isHidden = false
        downArrowIcon.isHidden = true
        
        deliveryAddressStackView.isHidden = false
        
        lblDeliveryAddress.numberOfLines = 0
        lblDeliveryLaneAddress.numberOfLines = 1
        
        let strDeliveryAddrText = "DELIVERY"
        let strIsHome = " @ " + (orderSummeryObject.selectedDeliveryAddressModel?.name!)!.uppercased()
        
        var strLaneAddr = AppDelegate.getAddressDescription(orderSummeryObject.selectedDeliveryAddressModel!)
        
        strLaneAddr = strLaneAddr.lowercased().capitalizingFirstLetter()
        
        let attrKeyDeliveryAddrText = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 2.5)]
        
        let attrKeyIsHome = [NSAttributedStringKey.foregroundColor : UIColor.gray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.7)]
        
        let attrKeyLaneAddr = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 1.2)]
        
        let attrDeliveryAddrText = NSMutableAttributedString(string: strDeliveryAddrText, attributes: attrKeyDeliveryAddrText)
        let attrIsHome = NSMutableAttributedString(string: strIsHome, attributes: attrKeyIsHome)
        let attrLaneAddr = NSMutableAttributedString(string: strLaneAddr, attributes: attrKeyLaneAddr)
        
        attrDeliveryAddrText.append(attrIsHome)
        
        lblDeliveryAddress.attributedText = attrDeliveryAddrText
        lblDeliveryLaneAddress.attributedText = attrLaneAddr
    }
    
    func doneAfterAddressSelectionPressedWith(pickupAddressModel: AddressModel, deliveryAddressModel: AddressModel) {
        orderSummeryObject.selectedPickupAddressModel = pickupAddressModel
        orderSummeryObject.selectedDeliveryAddressModel = deliveryAddressModel
        
        setupPickupAddress()
    }
    
    private func setupPickupAndDeliveryDateTimeSlots() {
        
        //Pickup
        let attrKeyPickupTitle = [NSAttributedStringKey.foregroundColor : AppColors.blueColor.withAlphaComponent(0.6), NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-2)!, NSAttributedStringKey.kern: NSNumber(value: 1.9)]
        let attrPickupTitle = NSAttributedString(string: "PICKUP", attributes: attrKeyPickupTitle)
        
        lblPickupTitle.attributedText = attrPickupTitle
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: orderSummeryObject.selectedPickupDate!)
        
        dateFormatter.dateFormat = "dd MMM"
        let formattedPickupDateStr = dateFormatter.string(from: date!).uppercased()
        
        let attrKeyPickupDate = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-4)!, NSAttributedStringKey.kern: NSNumber(value: 1.8)]
        let attrPickupDate = NSAttributedString(string: formattedPickupDateStr, attributes: attrKeyPickupDate)
        
        lblPickupDate.attributedText = attrPickupDate
        
        let attrKeyPickupTime = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 1.5)]
        let attrPickupTime = NSAttributedString(string: orderSummeryObject.selectedPickupTimeSlot!, attributes: attrKeyPickupTime)
        
        lblPickupTimeSlot.attributedText = attrPickupTime
        
        
        // Delivery
        let attrKeyDeliveryTitle = [NSAttributedStringKey.foregroundColor : AppColors.blueColor.withAlphaComponent(0.6), NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-2)!, NSAttributedStringKey.kern: NSNumber(value: 1.9)]
        let attrDeliveryTitle = NSAttributedString(string: "DELIVERY", attributes: attrKeyDeliveryTitle)
        
        lblDeliveryTitle.attributedText = attrDeliveryTitle
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd-MM-yyyy"
        dateFormatter2.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date2 = dateFormatter2.date(from: orderSummeryObject.selectedDeliveryDate!)
        
        dateFormatter2.dateFormat = "dd MMM"
        let formattedPickupDateStr2 = dateFormatter2.string(from: date2!).uppercased()
        
        let attrKeyDeliveryDate = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-4)!, NSAttributedStringKey.kern: NSNumber(value: 1.8)]
        let attrDeliveryDate = NSAttributedString(string: formattedPickupDateStr2, attributes: attrKeyDeliveryDate)
        
        lblDeliveryDate.attributedText = attrDeliveryDate
        
        let attrKeyDeliveryTime = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 1.5)]
        let attrDeliveryTime = NSAttributedString(string: orderSummeryObject.selectedDeliveryTimeSlot!, attributes: attrKeyDeliveryTime)
        
        lblDeliveryTimeSlot.attributedText = attrDeliveryTime
    }
    
    @IBAction private func submitButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction private func cancelButtonPressed(_ sender: UIButton) {
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
