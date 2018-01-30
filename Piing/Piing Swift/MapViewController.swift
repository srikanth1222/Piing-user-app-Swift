//
//  MapViewController.swift
//  Piing user
//
//  Created by Veedepu Srikanth on 05/09/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftGifOrigin


enum ServiceType : String {
    case UNKNOWN
    case LOADWASH = "WF"
    case DRYCLEANING = "DC"
    case WASHIRON = "WI"
    case IRONING = "IR"
    case GREEN_DRYCLEANING = "DCG"
    case BAGS = "BAG"
    case SHOE_CLEANING = "SHOECL"
    case SHOE_POLISHING = "SHOEPO"
    case LEATHER = "LE"
    case CARPET = "CA"
    case CURTAIN_WITH_DRYCLEANIG = "CC_W_DC"
    case CURTAIN_WITHOUT_DRYCLEANIG = "CC_DC"
}


class MapViewController: UIViewController, UIScrollViewDelegate, ShowAddressViewControllerDelegate {
    
    enum ServiceTypeTag : Int {
        case LOADWASH_TAG = 1
        case DRYCLEANING_TAG = 2
        case WASHIRON_TAG = 3
        case IRONING_TAG = 4
        case GREEN_DRYCLEANING_TAG = 5
        case BAGS_TAG = 6
        case SHOE_CLEANING_TAG = 7
        case SHOE_POLISHING_TAG = 8
        case LEATHER_TAG = 9
        case CURTAIN_TAG = 10
        case CARPET_TAG = 11
    }
    
    var serviceType = ServiceType.UNKNOWN
    
    @IBOutlet weak var topDropdownButton: UIButton! {
        didSet {
            topDropdownButton.imageView?.contentMode = .scaleAspectFit
            let insetValue:CGFloat = 15
            topDropdownButton.imageEdgeInsets = UIEdgeInsetsMake(insetValue/2, insetValue, insetValue, insetValue)
        }
    }
    
    @IBOutlet weak var containerViewAvailableTime: UIView!
    
    private  var customMapView: CustomMapView!
    
    @IBOutlet private weak var addressView: UIView!
    
    @IBOutlet private weak var addressViewTopSpace: NSLayoutConstraint! {
        didSet {
            //addressViewTopSpace.constant = -addressView.frame.size.height
        }
    }
    
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
    
    @IBOutlet private weak var topGradientEffectImageView: UIImageView! {
        didSet {
            topGradientEffectImageView.backgroundColor = .clear
        }
    }
    
    @IBOutlet private weak var topGradientFromTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topGradientHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var addressViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var bottomGradientEffectImageView: UIImageView! {
        didSet {
            bottomGradientEffectImageView.backgroundColor = .clear
        }
    }
    
    @IBOutlet private weak var lblPickupAddress: UILabel!
    @IBOutlet private weak var lblPickupLaneAddress: UILabel!
    
    @IBOutlet private weak var lblDeliveryAddress: UILabel!
    @IBOutlet private weak var lblDeliveryLaneAddress: UILabel!
    
    @IBOutlet private weak var upArrowIcon: UIImageView!
    @IBOutlet private weak var downArrowIcon: UIImageView!
    
    @IBOutlet private weak var servicesView: UIView!
    
    @IBOutlet private weak var scrollViewServices: UIScrollView!
    @IBOutlet private weak var scrollViewServicesTitle: UIScrollView!
    
    @IBOutlet private weak var personalCareView: UIView!
    @IBOutlet private weak var personalCaremultiplier: NSLayoutConstraint!
    @IBOutlet private weak var personalCareStackView: UIStackView!
    @IBOutlet private weak var ironingStackView: UIStackView!
    @IBOutlet private weak var washIronStackView: UIStackView!
    @IBOutlet private weak var dryCleaningStackView: UIStackView!
    @IBOutlet private weak var loadWashStackView: UIStackView!
    
    @IBOutlet private weak var loadWashBtn: UIButton!
    @IBOutlet private weak var dryCleaningBtn: UIButton!
    @IBOutlet private weak var washIronBtn: UIButton!
    @IBOutlet private weak var ironingBtn: UIButton!
    @IBOutlet private weak var bagsBtn: UIButton!
    @IBOutlet private weak var shoesBtn: UIButton!
    @IBOutlet private weak var leatherBtn: UIButton!
    @IBOutlet private weak var curtainsBtn: UIButton!
    @IBOutlet private weak var carpetBtn: UIButton!
    
    
    @IBOutlet private weak var lblLoadWash: UILabel!
    @IBOutlet private weak var lblDryCleaning: UILabel!
    @IBOutlet private weak var lblWashIron: UILabel!
    @IBOutlet private weak var lblIroning: UILabel!
    @IBOutlet private weak var lblBags: UILabel!
    @IBOutlet private weak var lblShoes: UILabel!
    @IBOutlet private weak var lblLeather: UILabel!
    @IBOutlet private weak var lblCurtain: UILabel!
    @IBOutlet private weak var lblCarpet: UILabel!
    
    @IBOutlet private weak var hexagonImageViewGif: UIImageView! {
        didSet {
            let hexagonGif = UIImage.gif(name: "hexagon_gif")
            hexagonImageViewGif.image = hexagonGif
        }
    }
    
    @IBOutlet private weak var pickupDateAndTimeButton: UIButton! {
        
        didSet {
            // Setting Pickup date and time
            
            pickupDateAndTimeButton.titleLabel?.numberOfLines = 2
            pickupDateAndTimeButton.imageView?.contentMode = .scaleAspectFit
            
            setupDateTimeLabel("")
        }
    }
    
    @IBOutlet private weak var dateTimeView: UIView! {
        
        didSet {
            // Intialize Tap Gesture for Pickup date and time slot View
            let tapPickupDatesGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnPickupDatesView))
            dateTimeView.addGestureRecognizer(tapPickupDatesGesture)
        }
    }
    
    @IBOutlet private weak var dateTimeViewBottomSpace: NSLayoutConstraint!
    
    private var btnGreenDC: UIButton!
    
    private lazy var greenDCStackView : UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        
        btnGreenDC = UIButton(type: .custom)
        btnGreenDC.tag = ServiceTypeTag.GREEN_DRYCLEANING_TAG.rawValue
        btnGreenDC.setImage(UIImage.init(named: "wash_iron"), for: .normal)
        btnGreenDC.imageView!.contentMode = .scaleAspectFit
        btnGreenDC.addTarget(self, action: #selector(serviceTypeButtonPressed(_:)), for: .touchUpInside)
        
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
        
        stackView.addArrangedSubview(btnGreenDC)
        stackView.addArrangedSubview(lblGreenDC)
        
        self.personalCareStackView.insertArrangedSubview(stackView, at: 2)
        stackView.isHidden = true
        
        return stackView
    }()
    
    @IBOutlet weak var locationPointer: UIButton! {
        didSet {
            locationPointer.alpha = 0
        }
    }
    
    private var orderSummeryObject = OrderSummeryModel()
    
    @IBAction func dropdownButtonPressed(_ sender: UIButton) {
        
        let dealsVC = self.parent as! DealsViewController
        
        let tap = UITapGestureRecognizer()
        dealsVC.tappedOnHomePage(tap)
    }
    
    @IBAction func locationPointerPressed(_ sender: UIButton) {
        customMapView.focusMapToShowAllMarkers()
        
        UIView.animate(withDuration: 0.2) {
            self.locationPointer.alpha = 0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = .white
        
        view.bringSubview(toFront: containerViewAvailableTime)
        
        customMapView = CustomMapView()
        self.view.addSubview(customMapView)
        
        customMapView.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint(item: customMapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: customMapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: customMapView, attribute: .top, relatedBy: .equal, toItem: addressView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: customMapView, attribute: .bottom, relatedBy: .equal, toItem: servicesView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        [
            customMapView.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 0),
            customMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            customMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            customMapView.bottomAnchor.constraint(equalTo: servicesView.topAnchor, constant: 0),
            ].forEach { ($0.isActive = true) }
        
        customMapView.mapView.delegate = self
        
        customMapView.perform(#selector(customMapView.animateMapView), with: nil, afterDelay: 1.5)
        
        orderSummeryObject = AppDelegate.orderSummeryObject
        
        setupUI()
        //self.perform(#selector(self.setupUI), with: nil, afterDelay: 1.5)
        
        checkBookingAvailable()
    }
    
    func checkBookingAvailable() {
        
        let bookingAvailableURL = WebServices.BASE_URL+WebServices.ORDER_BOOKING_AVAILABLE
        
        WebServices.serviceCall(withURLString: bookingAvailableURL, parameters: AppDelegate.constantDictValues, completionHandler: {[weak weakSelf = self] (error, responseObject, data) in
            
            guard case self? = weakSelf else { return }
            
            guard let responseObject = responseObject else { return }
            
            print (responseObject)
            
            let bookingResponse = responseObject as! Dictionary<String, Any>
            
            let dict1 = bookingResponse["order"] as! Dictionary<String, Any>
            
            if dict1["bookNow"] as! Bool == true {
                
                self.getNextAvailableTimeslot()
            }
        })
    }
    
    func getNextAvailableTimeslot() {
        let etaURL = WebServices.BASE_URL+WebServices.GET_ETA
        
        let versionNumber = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        
        var dictPrams: [String:Any] = ["pickupAddressId" : orderSummeryObject.selectedPickupAddressModel?._id as Any, "serviceTypes" : "WF", "orderType" : "S", "ver" : versionNumber]
        
        for(key, value) in AppDelegate.constantDictValues {
            dictPrams[key] = value
        }
        
        WebServices.serviceCall(withURLString: etaURL, parameters: dictPrams, completionHandler: {[weak weakSelf = self] (error, responseObject, data) in
            
            guard case self? = weakSelf else { return }
            
            guard let responseObject = responseObject else { return }
            
            print (responseObject)
            
            let etaResponse = responseObject as! Dictionary<String, Any>
            
            if etaResponse["s"] as! Bool {
                self.setupDateTimeLabel(etaResponse["slot"] as! String)
            }
            else {
                self.setupDateTimeLabel("")
            }
        })
    }
    
    func setupDateTimeLabel(_ time: String) {
        let strPickupDate = "PICKUP DATE : TIME"
        let strPickupTime = "\nNEXT PICKUP " + time
        
        let attrKeyPickupDate = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE)!]
        let attrKeyPickupTime = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-5)!]
        
        let attrPickupDate = NSMutableAttributedString(string: strPickupDate, attributes: attrKeyPickupDate)
        let attrPickupTime = NSMutableAttributedString(string: strPickupTime, attributes: attrKeyPickupTime)
        
        attrPickupDate.append(attrPickupTime)
        
        pickupDateAndTimeButton.setAttributedTitle(attrPickupDate, for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewServicesTitle.contentOffset.x =  (-view.frame.size.width * 0.17) + (scrollViewServices.contentOffset.x * 0.65)
    }
    
   
    
    @objc private func setupUI() {
        
        self.view.insertSubview(customMapView, at: 0)
        
        //dateTimeViewBottomSpace.constant = 0
        //addressViewTopSpace.constant = 0
        
        addressView.backgroundColor = .white
        //topGradientEffectImageView.backgroundColor = UIColor.red.withAlphaComponent(0.4)
        topGradientEffectImageView.backgroundColor = .clear
//        topGradientEffectImageView.image = nil
        topGradientEffectImageView.isUserInteractionEnabled = false
        
        //bottomGradientEffectImageView.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        bottomGradientEffectImageView.backgroundColor = .clear
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (success) in
            
            let getPickupStackFrame = self.pickupAddressStackView.convert(self.pickupAddressStackView.bounds, to: self.view)
            
            self.topGradientFromTopConstraint.constant = getPickupStackFrame.origin.y
            self.topGradientHeightConstraint.constant = getPickupStackFrame.size.height
            self.addressViewBottomConstraint.constant = -self.deliveryAddressStackView.frame.size.height
            //self.addressView.backgroundColor = .clear
            self.perform(#selector(self.changeCustomMapViewFrame), with: nil, afterDelay: 0.3)
            
            self.scrollViewServicesTitle.setContentOffset(CGPoint(x: (-self.view.frame.size.width * 0.17) + (self.scrollViewServices.contentOffset.x * 0.65), y: 0), animated: true)
        }
        
        //Setting ServiceType Header Labels
        settingUpServiceTypeHeaderLabels()
        
        //Setting ServiceType Labels
        settingUpServiceTypeLabels()
        
        // Setting Pickup address
        settingUpPickupAndDeliveryAddress()
        
        pickupDateAndTimeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -pickupDateAndTimeButton.frame.size.width * 0.18, 0, 0)
        pickupDateAndTimeButton.imageEdgeInsets = UIEdgeInsetsMake(pickupDateAndTimeButton.frame.size.height * 0.28, 0, pickupDateAndTimeButton.frame.size.height * 0.28, -pickupDateAndTimeButton.frame.size.width * 0.05)
    }
    
    @objc private func changeCustomMapViewFrame() {
        
        //self.customMapView.frame = CGRect(x: 0.0, y: self.topGradientEffectImageView.frame.origin.y + self.topGradientEffectImageView.frame.size.height / 2, width: self.view.frame.size.width, height: servicesView.frame.origin.y - (self.topGradientEffectImageView.frame.origin.y + 20))
    }
    
    private func settingUpPickupAndDeliveryAddress() {
        
        lblPickupAddress.numberOfLines = 0
        lblPickupLaneAddress.numberOfLines = 1
        
        let addressArrayWithDefault = orderSummeryObject.addressArray?.filter({$0.`default`!})
        
        var addressModel1: AddressModel? = nil
        
        guard let address = addressArrayWithDefault else { return }
        
        if address.count == 1 || address.count > 1 {
            
            addressModel1 = address[0]
        }
        else {
            return
        }
        
        guard let addressModel = addressModel1 else { return }
        
        orderSummeryObject.selectedPickupAddressModel = addressModel
        orderSummeryObject.selectedDeliveryAddressModel = orderSummeryObject.selectedPickupAddressModel
        
        customMapView.showCustomerMarkerOnTheMap(with: orderSummeryObject.selectedPickupAddressModel!)
        customMapView.focusMapToShowAllMarkers()
        
        setupPickupAddress()
    }
    
    private func setupPickupAddress() {
        
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
    
    private func settingUpServiceTypeLabels() {
        
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
    
    private func changeTopGradientMultiplierConstraint(With multiplier: CGFloat) {
        
        let newTopConstraint = self.topGradientFromTopConstraint.constraintWithMultiplier(multiplier)
        self.view!.removeConstraint(self.topGradientFromTopConstraint)
        self.view!.addConstraint(newTopConstraint)
        self.topGradientFromTopConstraint = newTopConstraint
    }
    
    private func settingUpServiceTypeHeaderLabels() {
        
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
    
    
    @IBAction private func serviceTypeButtonPressed(_ sender: UIButton) {
        
        let tag = sender.tag
        
        let serviceTypeTag = ServiceTypeTag(rawValue: tag)
        
        sender.isSelected = !sender.isSelected
        
        switch serviceTypeTag {
            
        case .LOADWASH_TAG?:
            serviceType = ServiceType.LOADWASH
            break
        case .DRYCLEANING_TAG?:
            //serviceType = ServiceType.DRYCLEANING
            
            handlingDryCleaning()
            
            break
        case .GREEN_DRYCLEANING_TAG?:
            
            greenDCSelected()
            //serviceType = ServiceType.GREEN_DRYCLEANING
            break
        case .WASHIRON_TAG?:
            serviceType = ServiceType.WASHIRON
            break
        case .IRONING_TAG?:
            serviceType = ServiceType.IRONING
            break
        case .BAGS_TAG?:
            serviceType = ServiceType.BAGS
            break
        case .SHOE_CLEANING_TAG?:
            serviceType = ServiceType.SHOE_CLEANING
            break
        case .SHOE_POLISHING_TAG?:
            serviceType = ServiceType.SHOE_POLISHING
            break
        case .LEATHER_TAG?:
            serviceType = ServiceType.LEATHER
            break
        case .CURTAIN_TAG?:
            serviceType = ServiceType.CURTAIN_WITH_DRYCLEANIG
            break
        case .CARPET_TAG?:
            serviceType = ServiceType.CARPET
            break
        default:
            print("No tag found")
        }
        
        if sender.isSelected {
            orderSummeryObject.selectedServiceTypes?.append(serviceType.rawValue)
        }
        else {
            if let index = orderSummeryObject.selectedServiceTypes?.index(of: serviceType.rawValue) {
                orderSummeryObject.selectedServiceTypes?.remove(at: index)
            }
        }
    }
    
    private func handlingDryCleaning() {
        
        if dryCleaningBtn.isSelected {
            if greenDCStackView == nil {
                greenDCStackView = UIStackView()
            }
            
            personalCareStackView.spacing = 0
            
            changePersonalCareMultiplier(with: 0.75)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.loadWashStackView.isHidden = true
                self.washIronStackView.isHidden = true
                self.ironingStackView.isHidden = true
                
                self.greenDCStackView.isHidden = false
                
            }) { (success) in
                
            }
        }
        else {
            personalCareStackView.spacing = 5
            
            changePersonalCareMultiplier(with: 0.96)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.loadWashStackView.isHidden = false
                self.washIronStackView.isHidden = false
                self.ironingStackView.isHidden = false
                
                self.greenDCStackView.isHidden = true
                
            }) { (success) in
                
            }
        }
    }
    
    private func greenDCSelected() {
        
        dryCleaningBtn.isSelected = false
        
        if btnGreenDC.isSelected {
            
            personalCareStackView.spacing = 5
            
            changePersonalCareMultiplier(with: 0.96)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.loadWashStackView.isHidden = false
                self.washIronStackView.isHidden = false
                self.ironingStackView.isHidden = false
                
                self.greenDCStackView.isHidden = true
                
            }) { (success) in
                
            }
        }
        else {
            personalCareStackView.spacing = 5
            
            changePersonalCareMultiplier(with: 0.96)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.loadWashStackView.isHidden = false
                self.washIronStackView.isHidden = false
                self.ironingStackView.isHidden = false
                
                self.greenDCStackView.isHidden = true
                
            }) { (success) in
                
            }
        }
    }
    
    @objc private func tappedOnPickupDatesView()
    {
        print("Tapped on pickup dates and timeslot stack view")
        
        guard let selectPickupDatesVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SelectPickupDatesViewController") as? SelectPickupDatesViewController else { return }
        selectPickupDatesVC.orderSummeryObject = orderSummeryObject
        
        let navPickupVC = UINavigationController(rootViewController: selectPickupDatesVC)
        navPickupVC.isNavigationBarHidden = true
        present(navPickupVC, animated: true, completion: nil)
        
    }
    
    func doneAfterAddressSelectionPressedWith(pickupAddressModel: AddressModel, deliveryAddressModel: AddressModel) {
        
        orderSummeryObject.selectedPickupAddressModel = pickupAddressModel
        orderSummeryObject.selectedDeliveryAddressModel = deliveryAddressModel
        
        setupPickupAddress()
        
        self.perform(#selector(changeTopGradientPosition), with: nil, afterDelay: 0.3)
    }
    
    @objc private func changeTopGradientPosition() {
    
        if orderSummeryObject.selectedPickupAddressModel?._id == orderSummeryObject.selectedDeliveryAddressModel?._id {
            let getPickupStackFrame = self.pickupAddressStackView.convert(self.pickupAddressStackView.bounds, to: self.view)
            self.topGradientFromTopConstraint.constant = getPickupStackFrame.origin.y
            self.topGradientHeightConstraint.constant = getPickupStackFrame.size.height
            self.addressViewBottomConstraint.constant = -self.deliveryAddressStackView.frame.size.height
            self.perform(#selector(self.changeCustomMapViewFrame), with: nil, afterDelay: 0.3)
        }
        else {
            let getDeliveryStackFrame = deliveryAddressStackView.convert(deliveryAddressStackView.bounds, to: self.view)
            self.topGradientFromTopConstraint.constant = getDeliveryStackFrame.origin.y
            self.topGradientHeightConstraint.constant = getDeliveryStackFrame.size.height
            self.addressViewBottomConstraint.constant = 0
            self.perform(#selector(self.changeCustomMapViewFrame), with: nil, afterDelay: 0.3)
        }
        
        self.perform(#selector(updateMapView), with: nil, afterDelay: 0.7)
    }
    
    @objc private func updateMapView() {
        customMapView.clearAllMarkers()
        customMapView.showMultipleMarkersOnTheMap(with: orderSummeryObject.selectedPickupAddressModel!)
        customMapView.showMultipleMarkersOnTheMap(with: orderSummeryObject.selectedDeliveryAddressModel!)
        customMapView.focusMapToShowAllMarkers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        dateTimeViewBottomSpace.constant = AppDelegate.safeAreaBottomInset()
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
    
    private func changePersonalCareMultiplier(with multiplier:CGFloat) {
        
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

extension MapViewController : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        if gesture {
            UIView.animate(withDuration: 0.2) {
                self.locationPointer.alpha = 1
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
//        guard let model = orderSummeryObject.selectedPickupAddressModel else { return }
//
//        let latitude = Double(model.lat!)!
//        let longitude = Double(model.lon!)!
//
//        let pos = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//
//        if position.target.latitude == pos.latitude {
//            locationPointer.isHidden = true
//        }
//        else {
//            locationPointer.isHidden = false
//        }
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


