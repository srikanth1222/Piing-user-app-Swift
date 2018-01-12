//
//  MapViewController.swift
//  Piing user
//
//  Created by Veedepu Srikanth on 05/09/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController, UIScrollViewDelegate, ShowAddressViewControllerDelegate {
    
    var customMapView: CustomMapView!
    
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var addressViewTopSpace: NSLayoutConstraint! {
        didSet {
            addressViewTopSpace.constant = -addressView.frame.size.height
        }
    }
    
    @IBOutlet weak var deliveryAddressStackView: UIStackView! {
        
        didSet {
            // Intialize Tap Gesture for Delivery Address Stack View
            let tapDeliveryGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnDeliveryAddressStackView))
            deliveryAddressStackView.addGestureRecognizer(tapDeliveryGesture)
        }
    }
    
    @IBOutlet weak var pickupAddressStackView: UIStackView! {
        
        didSet {
            // Intialize Tap Gesture for Pickup Address Stack View
            let tapPickupGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnPickupAddressStackView))
            pickupAddressStackView.addGestureRecognizer(tapPickupGesture)
        }
    }
    
    @IBOutlet weak var topGradientEffectImageView: UIImageView!
    @IBOutlet weak var topGradientFromTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topGradientHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addressViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomGradientEffectImageView: UIImageView!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblPickupLaneAddress: UILabel!
    
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblDeliveryLaneAddress: UILabel!
    
    @IBOutlet weak var upArrowIcon: UIImageView!
    @IBOutlet weak var downArrowIcon: UIImageView!
    
    @IBOutlet weak var servicesView: UIView!
    
    @IBOutlet weak var scrollViewServices: UIScrollView! 
    @IBOutlet weak var scrollViewServicesTitle: UIScrollView!
    
    @IBOutlet weak var personalCareView: UIView!
    @IBOutlet weak var personalCaremultiplier: NSLayoutConstraint!
    @IBOutlet weak var personalCareStackView: UIStackView!
    @IBOutlet weak var ironingStackView: UIStackView!
    @IBOutlet weak var washIronStackView: UIStackView!
    @IBOutlet weak var dryCleaningStackView: UIStackView!
    @IBOutlet weak var loadWashStackView: UIStackView!
    
    @IBOutlet weak var loadWashBtn: UIButton!
    @IBOutlet weak var dryCleaningBtn: UIButton!
    @IBOutlet weak var washIronBtn: UIButton!
    @IBOutlet weak var ironingBtn: UIButton!
    @IBOutlet weak var bagsBtn: UIButton!
    @IBOutlet weak var shoesBtn: UIButton!
    @IBOutlet weak var leatherBtn: UIButton!
    @IBOutlet weak var curtainsBtn: UIButton!
    @IBOutlet weak var carpetBtn: UIButton!
    
    
    @IBOutlet weak var lblLoadWash: UILabel!
    @IBOutlet weak var lblDryCleaning: UILabel!
    @IBOutlet weak var lblWashIron: UILabel!
    @IBOutlet weak var lblIroning: UILabel!
    @IBOutlet weak var lblBags: UILabel!
    @IBOutlet weak var lblShoes: UILabel!
    @IBOutlet weak var lblLeather: UILabel!
    @IBOutlet weak var lblCurtain: UILabel!
    @IBOutlet weak var lblCarpet: UILabel!
    
    @IBOutlet weak var hexagonImageViewButton: UIButton! {
        
        didSet {
            hexagonImageViewButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var pickupDateAndTimeButton: UIButton! {
        
        didSet {
            // Setting Pickup date and time
            
            pickupDateAndTimeButton.titleLabel?.numberOfLines = 2
            //lblPickupDateAndTime.backgroundColor = .red
            
            let strPickupDate = "PICKUP DATE : TIME"
            let strPickupTime = "\nNEXT PICKUP 3 - 4 PM"
            
            let attrKeyPickupDate = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE)!]
            let attrKeyPickupTime = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-5)!]
            
            let attrPickupDate = NSMutableAttributedString(string: strPickupDate, attributes: attrKeyPickupDate)
            let attrPickupTime = NSMutableAttributedString(string: strPickupTime, attributes: attrKeyPickupTime)
            
            attrPickupDate.append(attrPickupTime)
            
            pickupDateAndTimeButton.setAttributedTitle(attrPickupDate, for: .normal)
            
            pickupDateAndTimeButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var dateTimeView: UIView! {
        
        didSet {
            // Intialize Tap Gesture for Pickup date and time slot View
            let tapPickupDatesGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnPickupDatesView))
            dateTimeView.addGestureRecognizer(tapPickupDatesGesture)
        }
    }
    
    @IBOutlet weak var dateTimeViewBottomSpace: NSLayoutConstraint! {
        
        didSet {
            dateTimeViewBottomSpace.constant = -(dateTimeView.frame.size.height + addressView.frame.size.height)
        }
    }
    
    var greenDCTSTackView = UIStackView()
    
    var responseObject: ResponseModel?
    var addressArray : [AddressModel]?
    var selectedPickupAddressModel: AddressModel?
    var selectedDeliveryAddressModel: AddressModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = .white
        
        customMapView = CustomMapView(frame: CGRect(x: 0.0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(customMapView)
        customMapView.perform(#selector(customMapView.animateMapView), with: nil, afterDelay: 1.5)
        
        let addressURLString = WebServices.BASE_URL+WebServices.GET_ADDRESS
        
        WebServices.serviceCall(withURLString: addressURLString, parameters: AppDelegate.constantDictValues) { (error, responseObject, data) in
            
            guard let responseObject = responseObject else { return }
            
            print (responseObject)
            
            guard let data = data else { return }
            
            do {
                
                self.responseObject = try JSONDecoder().decode(ResponseModel.self, from: data)
                
                print (self.responseObject as Any)
                
                if self.responseObject?.s == 100 {
                    AppDelegate.logoutFromTheApp()
                    return
                }
                
                self.perform(#selector(self.setupUI), with: nil, afterDelay: 1.5)
                
                //self.setupUI()
                
            }  catch let jsonDecodeErr {
                
                print("Error while parsing addresses: \(jsonDecodeErr)")
            }
        }
    }
    
    @objc func setupUI() {
        
        self.view.insertSubview(customMapView, at: 0)
        
        dateTimeViewBottomSpace.constant = 0
        addressViewTopSpace.constant = 0
        
        addressView.backgroundColor = .white
        topGradientEffectImageView.backgroundColor = .clear
//        topGradientEffectImageView.backgroundColor = .red
//        topGradientEffectImageView.image = nil
        topGradientEffectImageView.isUserInteractionEnabled = false
        
        bottomGradientEffectImageView.backgroundColor = .clear
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (success) in
            
            let getPickupStackFrame = self.pickupAddressStackView.convert(self.pickupAddressStackView.bounds, to: self.view)
            
            self.topGradientFromTopConstraint.constant = getPickupStackFrame.origin.y - AppDelegate.safeAreaTopInset()
            
            self.topGradientHeightConstraint.constant = getPickupStackFrame.size.height * 2
            self.addressViewBottomConstraint.constant = -self.deliveryAddressStackView.frame.size.height
            self.addressView.backgroundColor = .clear
            self.perform(#selector(self.changeCustomMapViewFrame), with: nil, afterDelay: 0.3)
            
            self.scrollViewServicesTitle.setContentOffset(CGPoint(x: (-self.view.frame.size.width * 0.17) + (self.scrollViewServices.contentOffset.x * 0.65), y: 0), animated: true)
        }
        
        //Setting ServiceType Header Labels
        settingUpServiceTypeHeaderLabels()
        
        //Setting ServiceType Labels
        settingUpServiceTypeLabels()
        
        // Setting Pickup address
        settingUpPickupAndDeliveryAddress()
        
        hexagonImageViewButton.imageEdgeInsets = UIEdgeInsetsMake(hexagonImageViewButton.frame.size.height * 0.1, 0, hexagonImageViewButton.frame.size.height * 0.1, 0)
        
        pickupDateAndTimeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -pickupDateAndTimeButton.frame.size.width * 0.18, 0, 0)
        pickupDateAndTimeButton.imageEdgeInsets = UIEdgeInsetsMake(pickupDateAndTimeButton.frame.size.height * 0.28, 0, pickupDateAndTimeButton.frame.size.height * 0.28, -pickupDateAndTimeButton.frame.size.width * 0.05)
    }
    
    @objc func changeCustomMapViewFrame() {
        self.customMapView.frame = CGRect(x: 0.0, y: self.topGradientEffectImageView.frame.origin.y + self.topGradientEffectImageView.frame.size.height / 2, width: self.view.frame.size.width, height: servicesView.frame.origin.y - (self.topGradientEffectImageView.frame.origin.y + 20))
    }
    
    func settingUpPickupAndDeliveryAddress() {
        
        lblPickupAddress.numberOfLines = 0
        lblPickupLaneAddress.numberOfLines = 1
        
        addressArray = self.responseObject?.addresses
        
        let addressArrayWithDefault = addressArray?.filter({$0.`default`!})
        
        var addressModel1: AddressModel? = nil
        
        guard let address = addressArrayWithDefault else { return }
        
        if address.count == 1 || address.count > 1 {
            
            addressModel1 = address[0]
        }
        else {
            return
        }
        
        guard let addressModel = addressModel1 else { return }
        
        selectedPickupAddressModel = addressModel
        selectedDeliveryAddressModel = selectedPickupAddressModel
        
        customMapView.showCustomerMarkerOnTheMap(with: selectedPickupAddressModel!)
        customMapView.focusMapToShowAllMarkers()
        
        setupPickupAddress()
    }
    
    func setupPickupAddress() {
        
        upArrowIcon.isHidden = false
        downArrowIcon.isHidden = false
        
        deliveryAddressStackView.isHidden = true
        
        let strPickupAddrText = "PICKUP"
        
        guard var strIsHome = selectedPickupAddressModel?.name else { return }
        
        strIsHome = "  @ " + strIsHome.uppercased()
        
        var strLaneAddr = AppDelegate.getAddressDescription(selectedPickupAddressModel!)
        
        strLaneAddr = strLaneAddr.lowercased().capitalizingFirstLetter()
        
        let attrKeyPickupAddrText = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 2.5)]
        
        let attrKeyDeliveryAddrText = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 2.5)]
        
        let attrKeyIsHome = [NSAttributedStringKey.foregroundColor : UIColor.gray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.7)]
        
        let attrKeyLaneAddr = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 1.2)]
        
        let attrPickupAddrText = NSMutableAttributedString(string: strPickupAddrText, attributes: attrKeyPickupAddrText)
        
        if selectedPickupAddressModel?._id == selectedDeliveryAddressModel?._id {
            
            let strSeparator = " |  "
            let strDeliveryAddrText = "DELIVERY"
            
            let attrKeySeparator = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-6)!]
            
            let attrSeparator = NSMutableAttributedString(string: strSeparator, attributes: attrKeySeparator)
            let attrDeliveryAddrText = NSMutableAttributedString(string: strDeliveryAddrText, attributes: attrKeyDeliveryAddrText)
            
            attrPickupAddrText.append(attrSeparator)
            attrPickupAddrText.append(attrDeliveryAddrText)
        }
        
        let attrIsHome = NSMutableAttributedString(string: strIsHome, attributes: attrKeyIsHome)
        let attrLaneAddr = NSMutableAttributedString(string: strLaneAddr, attributes: attrKeyLaneAddr)
        
        attrPickupAddrText.append(attrIsHome)
        
        lblPickupAddress.attributedText = attrPickupAddrText
        lblPickupLaneAddress.attributedText = attrLaneAddr
        //lblPickupLaneAddress.backgroundColor = .red
    }
    
    func setupDeliveryAddress() {
        
        upArrowIcon.isHidden = false
        downArrowIcon.isHidden = true
        
        deliveryAddressStackView.isHidden = false
        
        lblDeliveryAddress.numberOfLines = 0
        lblDeliveryLaneAddress.numberOfLines = 1
        
        let strDeliveryAddrText = "DELIVERY"
        let strIsHome = " @ " + (selectedDeliveryAddressModel?.name!)!.uppercased()
        
        var strLaneAddr = AppDelegate.getAddressDescription(selectedDeliveryAddressModel!)
        
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
    
    func settingUpServiceTypeLabels() {
        
        loadWashBtn.imageView!.contentMode = .scaleAspectFit
        dryCleaningBtn.imageView!.contentMode = .scaleAspectFit
        washIronBtn.imageView!.contentMode = .scaleAspectFit
        ironingBtn.imageView!.contentMode = .scaleAspectFit
        bagsBtn.imageView!.contentMode = .scaleAspectFit
        shoesBtn.imageView!.contentMode = .scaleAspectFit
        leatherBtn.imageView!.contentMode = .scaleAspectFit
        curtainsBtn.imageView!.contentMode = .scaleAspectFit
        carpetBtn.imageView!.contentMode = .scaleAspectFit
        
        
        let attrKeyLoadwash = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrLoadwash = NSAttributedString(string: "LOAD WASH", attributes: attrKeyLoadwash)
        
        lblLoadWash.attributedText = attrLoadwash
        lblLoadWash.minimumScaleFactor = 0.5
        
        let attrKeyDC = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrDC = NSAttributedString(string: "DRY CLEANING", attributes: attrKeyDC)
        
        lblDryCleaning.attributedText = attrDC
        lblDryCleaning.minimumScaleFactor = 0.5
        
        let attrKeyWashiron = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrWashiron = NSAttributedString(string: "WASH & IRON", attributes: attrKeyWashiron)
        
        lblWashIron.attributedText = attrWashiron
        lblWashIron.minimumScaleFactor = 0.5
        
        let attrKeyIroning = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrIroning = NSAttributedString(string: "IRONING", attributes: attrKeyIroning)
        
        lblIroning.attributedText = attrIroning
        lblIroning.minimumScaleFactor = 0.5
        
        let attrKeyBags = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrBags = NSAttributedString(string: "BAGS", attributes: attrKeyBags)
        
        lblBags.attributedText = attrBags
        lblBags.minimumScaleFactor = 0.5
        
        let attrKeyShoes = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrShoes = NSAttributedString(string: "SHOES", attributes: attrKeyShoes)
        
        lblShoes.attributedText = attrShoes
        lblShoes.minimumScaleFactor = 0.5
        
        let attrKeyLeather = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrLeather = NSAttributedString(string: "LEATHER", attributes: attrKeyLeather)
        
        lblLeather.attributedText = attrLeather
        lblLeather.minimumScaleFactor = 0.5
        
        let attrKeyCurtain = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrCurtain = NSAttributedString(string: "CURTAINS", attributes: attrKeyCurtain)
        
        lblCurtain.attributedText = attrCurtain
        lblCurtain.minimumScaleFactor = 0.5
        
        let attrKeyCarpet = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrCarpet = NSAttributedString(string: "CARPET", attributes: attrKeyCarpet)
        
        lblCarpet.attributedText = attrCarpet
        lblCarpet.minimumScaleFactor = 0.5
    }
    
    func changeTopGradientMultiplierConstraint(With multiplier: CGFloat) {
        
        let newTopConstraint = self.topGradientFromTopConstraint.constraintWithMultiplier(multiplier)
        self.view!.removeConstraint(self.topGradientFromTopConstraint)
        self.view!.addConstraint(newTopConstraint)
        self.topGradientFromTopConstraint = newTopConstraint
    }
    
    func settingUpServiceTypeHeaderLabels() {
        
        let arrayServicesTitle = ["GARMENTS & LINEN", "BAGS SHOES & MORE", "CURTAINS & CARPETS"]
        
        var count:Int = 0
        
        for title in arrayServicesTitle {
            
            let lblTitle = UILabel(frame: CGRect(x: (view.frame.size.width * 0.65) * CGFloat(count), y: 0, width: (view.frame.size.width * 0.65), height: self.scrollViewServicesTitle.frame.size.height))
            //lblTitle.translatesAutoresizingMaskIntoConstraints = false
            let attrKeyTitle = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-2)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
            let attrTitle = NSMutableAttributedString(string: title, attributes: attrKeyTitle)
            
            lblTitle.attributedText = attrTitle
            lblTitle.textAlignment = .center
            self.scrollViewServicesTitle.addSubview(lblTitle)
            
            count += 1
        }
        
        //scrollViewServicesTitle.contentOffset.x =  (-view.frame.size.width * 0.17) + (scrollViewServices.contentOffset.x * 0.65)
        
        let lblLineUnderServiceTypeHeaderTitles = UILabel(frame: CGRect(x: view.frame.size.width/2-((view.frame.size.width * 0.15)/2), y: self.scrollViewServicesTitle.frame.size.height * 0.9, width: view.frame.size.width * 0.15, height: 2))
        //lblLineUnderServiceTypeHeaderTitles.translatesAutoresizingMaskIntoConstraints = false
        lblLineUnderServiceTypeHeaderTitles.backgroundColor = AppColors.blueColor
        servicesView.addSubview(lblLineUnderServiceTypeHeaderTitles);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        scrollViewServicesTitle.contentOffset.x =  (-view.frame.size.width * 0.17) + (scrollViewServices.contentOffset.x * 0.65)
        //scrollViewServicesTitle.backgroundColor = .red
    }
    
    @objc func tappedOnPickupAddressStackView()
    {
        print("Tapped on pickup address stack view")
        
        guard let showAddress = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "ShowAddressViewController") as? ShowAddressViewController else { return }
        showAddress.addressArray = addressArray
        showAddress.pickupAddressModel = selectedPickupAddressModel
        showAddress.deliveryAddressModel = selectedDeliveryAddressModel
        showAddress.delegate = self
        
        let navShowAddrVC = UINavigationController(rootViewController: showAddress)
        navShowAddrVC.isNavigationBarHidden = true
        present(navShowAddrVC, animated: true, completion: nil)
    }
    
    @objc func tappedOnDeliveryAddressStackView()
    {
        print("Tapped on delivery address stack view")
        
        guard let showAddress = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "ShowAddressViewController") as? ShowAddressViewController else { return }
        showAddress.addressArray = addressArray
        showAddress.pickupAddressModel = selectedPickupAddressModel
        showAddress.deliveryAddressModel = selectedDeliveryAddressModel
        showAddress.delegate = self
        
        let navShowAddrVC = UINavigationController(rootViewController: showAddress)
        navShowAddrVC.isNavigationBarHidden = true
        present(navShowAddrVC, animated: true, completion: nil)
    }
    
    
    @objc func tappedOnPickupDatesView()
    {
        print("Tapped on pickup dates and timeslot stack view")
        
        guard let selectPickupDatesVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SelectPickupDatesViewController") as? SelectPickupDatesViewController else { return }
        selectPickupDatesVC.addressModel = selectedPickupAddressModel
        
        let navPickupVC = UINavigationController(rootViewController: selectPickupDatesVC)
        navPickupVC.isNavigationBarHidden = true
        present(navPickupVC, animated: true, completion: nil)
        
    }
    
    func doneAfterAddressSelectionPressedWith(pickupAddressModel: AddressModel, deliveryAddressModel: AddressModel) {
        
        selectedPickupAddressModel = pickupAddressModel
        selectedDeliveryAddressModel = deliveryAddressModel
        
        setupPickupAddress()
        
        if selectedPickupAddressModel?._id == selectedDeliveryAddressModel?._id {
           
        }
        else {
            setupDeliveryAddress()
        }
        
        self.perform(#selector(changeTopGradientPosition), with: nil, afterDelay: 0.3)
        
    }
    
    @objc func changeTopGradientPosition() {
    
        if selectedPickupAddressModel?._id == selectedDeliveryAddressModel?._id {
            let getPickupStackFrame = self.pickupAddressStackView.convert(self.pickupAddressStackView.bounds, to: self.view)
            self.topGradientFromTopConstraint.constant = getPickupStackFrame.origin.y - AppDelegate.safeAreaTopInset()
            self.topGradientHeightConstraint.constant = getPickupStackFrame.size.height * 2
            self.addressViewBottomConstraint.constant = -self.deliveryAddressStackView.frame.size.height
            self.perform(#selector(self.changeCustomMapViewFrame), with: nil, afterDelay: 0.3)
        }
        else {
            let getDeliveryStackFrame = deliveryAddressStackView.convert(deliveryAddressStackView.bounds, to: self.view)
            self.topGradientFromTopConstraint.constant = getDeliveryStackFrame.origin.y - AppDelegate.safeAreaTopInset()
            self.topGradientHeightConstraint.constant = getDeliveryStackFrame.size.height * 2
            self.addressViewBottomConstraint.constant = 0
            self.perform(#selector(self.changeCustomMapViewFrame), with: nil, afterDelay: 0.3)
        }
        
        self.perform(#selector(updateMapView), with: nil, afterDelay: 0.7)
        
    }
    
    @objc func updateMapView() {
        customMapView.clearAllMarkers()
        customMapView.showMultipleMarkersOnTheMap(with: selectedPickupAddressModel!)
        customMapView.showMultipleMarkersOnTheMap(with: selectedDeliveryAddressModel!)
        customMapView.focusMapToShowAllMarkers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == scrollViewServices {
            //let page = scrollView.contentOffset.x/view.frame.size.width
            
            //print("page: \(page)")
            
            if scrollView.contentOffset.y != 0 {
                scrollView.contentOffset.y = 0
            }
            
            scrollViewServicesTitle.contentOffset.x =  (-view.frame.size.width * 0.17) + (scrollView.contentOffset.x * 0.65)
        }
    }
    
    @IBAction func btnDryCleaningPressed(_ sender: UIButton) {
        
        if !sender.isSelected {
            
            sender.isSelected = true
            
            greenDCTSTackView.axis = .vertical
            //greenDCTSTackView.spacing = -4
            greenDCTSTackView.alignment = .center
            
            if greenDCTSTackView.subviews.count == 0
            {
                let btnGreenDC = UIButton(type: .custom)
                btnGreenDC.setImage(UIImage.init(named: "wash_iron"), for: .normal)
                btnGreenDC.imageView!.contentMode = .scaleAspectFit
                btnGreenDC.addTarget(self, action: #selector(btnGreenDCPressed(_:)), for: .touchUpInside)
                btnGreenDC.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 749), for: .vertical)
                
                let aspectRatioConstraint = NSLayoutConstraint(item: btnGreenDC, attribute: .height, relatedBy: .equal, toItem: btnGreenDC, attribute: .width, multiplier: (1.0 / 1.0),constant: 0)
                btnGreenDC.addConstraint(aspectRatioConstraint)
                
                let lblGreenDC = UILabel()
                let attrKeyIroning = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
                let attrIroning = NSAttributedString(string: "Green DryCleaning".uppercased(), attributes: attrKeyIroning)
                
                lblGreenDC.attributedText = attrIroning
                lblGreenDC.minimumScaleFactor = 0.5
                
                lblGreenDC.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 751), for: .vertical)
                lblGreenDC.setContentHuggingPriority(UILayoutPriority.init(rawValue: 1000), for: .vertical)
                
                greenDCTSTackView.addArrangedSubview(btnGreenDC)
                greenDCTSTackView.addArrangedSubview(lblGreenDC)
                
                self.personalCareStackView.insertArrangedSubview(greenDCTSTackView, at: 2)
                greenDCTSTackView.isHidden = true
            }
            
            personalCareStackView.spacing = 0
            
            changePersonalCareMultiplier(with: 0.75)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.loadWashStackView.isHidden = true
                self.washIronStackView.isHidden = true
                self.ironingStackView.isHidden = true
                
                self.greenDCTSTackView.isHidden = false
                
            }) { (success) in
                
            }
        }
        else {
            
            sender.isSelected = false
            
            personalCareStackView.spacing = 5
            
            changePersonalCareMultiplier(with: 0.96)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.loadWashStackView.isHidden = false
                self.washIronStackView.isHidden = false
                self.ironingStackView.isHidden = false
                
                self.greenDCTSTackView.isHidden = true
                
            }) { (success) in
                
            }
        }
        
        scrollViewServicesTitle.contentOffset.x =  (-view.frame.size.width * 0.17) + (scrollViewServices.contentOffset.x * 0.65)
        
    }
    
    @objc func btnGreenDCPressed(_ sender: UIButton) {
        
        dryCleaningBtn.isSelected = false
        
        personalCareStackView.spacing = 5
        
        changePersonalCareMultiplier(with: 0.96)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.loadWashStackView.isHidden = false
            self.washIronStackView.isHidden = false
            self.ironingStackView.isHidden = false
            
            self.greenDCTSTackView.isHidden = true
            
        }) { (success) in
            
        }
    }
    
    func changePersonalCareMultiplier(with multiplier:CGFloat) {
        
        let newConstraint = self.personalCaremultiplier.constraintWithMultiplier(multiplier)
        self.view!.removeConstraint(self.personalCaremultiplier)
        self.view!.addConstraint(newConstraint)
        self.personalCaremultiplier = newConstraint
        self.view!.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem as Any, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


