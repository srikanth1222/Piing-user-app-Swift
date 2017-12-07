//
//  MapViewController.swift
//  Piing user
//
//  Created by Veedepu Srikanth on 05/09/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController, UIScrollViewDelegate {
    
    var mapView: GMSMapView!
    
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var deliveryAddressStackView: UIStackView!
    @IBOutlet weak var pickupAddressStackView: UIStackView!
    
    @IBOutlet weak var topGradientEffectImageView: UIImageView!
    @IBOutlet weak var topGradientMultiplierConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomGradientEffectImageView: UIImageView!
    @IBOutlet weak var bottomGradientMultiplierConstraint: NSLayoutConstraint!
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
    
    
    
    @IBOutlet weak var lblPickupDateAndTime: UILabel!
    @IBOutlet weak var dateTimeView: UIView!
    
    var greenDCTSTackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        //let camera = GMSCameraPosition.camera(withLatitude: 1.307924, longitude: 103.840963, zoom: 14.0)
        let camera = GMSCameraPosition.camera(withLatitude: 1.307924, longitude: 103.840963, zoom: 14.0, bearing: 270, viewingAngle: 0)
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height * 0.8), camera: camera)
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        self.view.addSubview(mapView)
        
        let customMarker = GMSMarker()
        customMarker.icon = UIImage.init(named: "home_map_icon")
        customMarker.appearAnimation = .pop
        //customMarker.groundAnchor = CGPoint(x: 0.5, y: 0.2);
        customMarker.position = CLLocationCoordinate2D(latitude: 1.307924, longitude: 103.840963)
        customMarker.map = mapView
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewServices.contentSize = CGSize(width: view.frame.size.width*3, height: scrollViewServices.frame.size.height)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.view.insertSubview(servicesView, aboveSubview: mapView)
        self.view.insertSubview(dateTimeView, aboveSubview: mapView)
        self.view.insertSubview(addressView, aboveSubview: mapView)
        
        self.view.insertSubview(bottomGradientEffectImageView, aboveSubview: mapView)
        self.view.insertSubview(topGradientEffectImageView, aboveSubview: mapView)
        
        // Intialize Tap Gesture for Pickup Address Stack View
        let tapPickupGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnPickupAddressStackView))
        pickupAddressStackView.addGestureRecognizer(tapPickupGesture)
        
        // Intialize Tap Gesture for Delivery Address Stack View
        let tapDeliveryGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnDeliveryAddressStackView))
        deliveryAddressStackView.addGestureRecognizer(tapDeliveryGesture)
        
        // Intialize Tap Gesture for Pickup date and time slot View
        let tapPickupDatesGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnPickupDatesView))
        dateTimeView.addGestureRecognizer(tapPickupDatesGesture)
    }
    
    @objc func tapOnPickupAddressStackView()
    {
        print("Tapped on pickup address stack view")
    }
    
    @objc func tapOnDeliveryAddressStackView()
    {
        print("Tapped on delivery address stack view")
    }
    
    
    
    @objc func tapOnPickupDatesView()
    {
        print("Tapped on pickup dates and timeslot stack view")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let selectPickupDatesVC = storyBoard.instantiateViewController(withIdentifier: "SelectPickupDatesViewController") as? SelectPickupDatesViewController else { return }
        
        present(selectPickupDatesVC, animated: true, completion: nil)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let arrayServicesTitle = ["GARMENTS & LINEN", "BAGS SHOES & MORE", "CURTAINS & CARPETS"]
        
        //scrollViewServicesTitle.backgroundColor = .red
        
        var count:Int = 0
        
        
        for title in arrayServicesTitle {
            
            let lblTitle = UILabel(frame: CGRect(x: (view.frame.size.width * 0.65) * CGFloat(count), y: 0, width: (view.frame.size.width * 0.65), height: scrollViewServicesTitle.frame.size.height))
            
            let attrKeyTitle = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-2)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
            let attrTitle = NSMutableAttributedString(string: title, attributes: attrKeyTitle)
            
            lblTitle.attributedText = attrTitle
            lblTitle.textAlignment = .center
            scrollViewServicesTitle.addSubview(lblTitle)
            
            count += 1
        }
        
        let getframe = scrollViewServicesTitle.convert(scrollViewServicesTitle.bounds, to: self.view)
        
        print(getframe)
        
        let lblLine = UILabel(frame: CGRect(x: view.frame.size.width/2-((view.frame.size.width * 0.15)/2), y: getframe.origin.y+scrollViewServicesTitle.frame.size.height * 0.8, width: view.frame.size.width * 0.15, height: 2))
        lblLine.backgroundColor = AppColors.blueColor
        self.view.addSubview(lblLine);
        
        //scrollViewServicesTitle.backgroundColor = .red
        
        scrollViewServicesTitle.contentOffset.x =  (-view.frame.size.width * 0.17) + (scrollViewServices.contentOffset.x * 0.65)
        
        //upArrowIcon.isHidden = true
        downArrowIcon.isHidden = false
        
        
        // Setting Pickup date and time
        
        lblPickupDateAndTime.numberOfLines = 0
        
        let strPickupDate = "PICKUP DATE : TIME"
        let strPickupTime = "\nNEXT PICKUP 3 - 4 PM"
        
        
        let attrKeyPickupDate = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE)!]
        let attrKeyPickupTime = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-5)!]
        
        let attrPickupDate = NSMutableAttributedString(string: strPickupDate, attributes: attrKeyPickupDate)
        let attrPickupTime = NSMutableAttributedString(string: strPickupTime, attributes: attrKeyPickupTime)
        
        attrPickupDate.append(attrPickupTime)
        
        lblPickupDateAndTime.attributedText = attrPickupDate
        
        
        // Setting Pickup address
        
        deliveryAddressStackView.isHidden = true
        
        lblPickupAddress.numberOfLines = 0
        lblPickupLaneAddress.numberOfLines = 0
        
        let boolenVar : Bool = true
        
        if (boolenVar)
        {
            let strPickupAddrText = "PICKUP"
            let strSeparator = " | "
            let strDeliveryAddrText = "DELIVERY"
            let strIsHome = " @ HOME"
            let strLaneAddr = "403 Havelock Rd Singapore 229491"
            
            let attrKeyPickupAddrText = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 1.5)]
            
            let attrKeySeparator = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-6)!]
            
            let attrKeyDeliveryAddrText = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 1.5)]
            
            let attrKeyIsHome = [NSAttributedStringKey.foregroundColor : UIColor.gray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-6)!, NSAttributedStringKey.kern: NSNumber(value: 0.7)]
            
            let attrKeyLaneAddr = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-6)!, NSAttributedStringKey.kern: NSNumber(value: 1.2)]
            
            let attrPickupAddrText = NSMutableAttributedString(string: strPickupAddrText, attributes: attrKeyPickupAddrText)
            let attrSeparator = NSMutableAttributedString(string: strSeparator, attributes: attrKeySeparator)
            let attrDeliveryAddrText = NSMutableAttributedString(string: strDeliveryAddrText, attributes: attrKeyDeliveryAddrText)
            let attrIsHome = NSMutableAttributedString(string: strIsHome, attributes: attrKeyIsHome)
            let attrLaneAddr = NSMutableAttributedString(string: strLaneAddr, attributes: attrKeyLaneAddr)
            
            attrPickupAddrText.append(attrSeparator)
            attrPickupAddrText.append(attrDeliveryAddrText)
            attrPickupAddrText.append(attrIsHome)
            
            //        let paragraphStyle = NSMutableParagraphStyle()
            //        paragraphStyle.lineSpacing = 4
            //        attrOne.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrOne.length))
            
            lblPickupAddress.attributedText = attrPickupAddrText
            lblPickupLaneAddress.attributedText = attrLaneAddr
        }
        
        lblDeliveryAddress.numberOfLines = 0
        lblDeliveryLaneAddress.numberOfLines = 0
        
        if (!boolenVar)
        {
            let strPickupAddrText = "DELIVERY"
//            let strSeparator = " | "
//            let strDeliveryAddrText = "DELIVERY"
            let strIsHome = " @ WORK"
            let strLaneAddr = "403 Havelock Rd Singapore 229491"
            
            let attrKeyPickupAddrText = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: AppDelegate.GLOBAL_FONT_SIZE-3), NSAttributedStringKey.kern: NSNumber(value: 0.7)]
            
//            let attrKeySeparator = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12.5)]
//
//            let attrKeyDeliveryAddrText = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.kern: NSNumber(value: 0.8)]
            
            let attrKeyIsHome = [NSAttributedStringKey.foregroundColor : UIColor.gray, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: AppDelegate.GLOBAL_FONT_SIZE-4), NSAttributedStringKey.kern: NSNumber(value: 0.7)]
            
            let attrKeyLaneAddr = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: AppDelegate.GLOBAL_FONT_SIZE-4), NSAttributedStringKey.kern: NSNumber(value: 0.7)]
            
            let attrPickupAddrText = NSMutableAttributedString(string: strPickupAddrText, attributes: attrKeyPickupAddrText)
//            let attrSeparator = NSMutableAttributedString(string: strSeparator, attributes: attrKeySeparator)
//            let attrDeliveryAddrText = NSMutableAttributedString(string: strDeliveryAddrText, attributes: attrKeyDeliveryAddrText)
            let attrIsHome = NSMutableAttributedString(string: strIsHome, attributes: attrKeyIsHome)
            let attrLaneAddr = NSMutableAttributedString(string: strLaneAddr, attributes: attrKeyLaneAddr)
            
            //attrPickupAddrText.append(attrSeparator)
            //attrPickupAddrText.append(attrDeliveryAddrText)
            attrPickupAddrText.append(attrIsHome)
            
            //        let paragraphStyle = NSMutableParagraphStyle()
            //        paragraphStyle.lineSpacing = 4
            //        attrOne.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrOne.length))
            
            lblDeliveryAddress.attributedText = attrPickupAddrText
            lblDeliveryLaneAddress.attributedText = attrLaneAddr
        }
        
        
        loadWashBtn.imageView!.contentMode = .scaleAspectFit
        
        dryCleaningBtn.imageView!.contentMode = .scaleAspectFit
        
        washIronBtn.imageView!.contentMode = .scaleAspectFit
        
        ironingBtn.imageView!.contentMode = .scaleAspectFit
        
        bagsBtn.imageView!.contentMode = .scaleAspectFit
        
        shoesBtn.imageView!.contentMode = .scaleAspectFit
        
        leatherBtn.imageView!.contentMode = .scaleAspectFit
        
        curtainsBtn.imageView!.contentMode = .scaleAspectFit
        
        carpetBtn.imageView!.contentMode = .scaleAspectFit
        
        
        let attrKeyLoadwash = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrLoadwash = NSAttributedString(string: "LOAD WASH", attributes: attrKeyLoadwash)
        
        lblLoadWash.attributedText = attrLoadwash
        lblLoadWash.minimumScaleFactor = 0.5
        
        let attrKeyDC = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrDC = NSAttributedString(string: "DRY CLEANING", attributes: attrKeyDC)
        
        lblDryCleaning.attributedText = attrDC
        lblDryCleaning.minimumScaleFactor = 0.5
        
        let attrKeyWashiron = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrWashiron = NSAttributedString(string: "WASH & IRON", attributes: attrKeyWashiron)
        
        lblWashIron.attributedText = attrWashiron
        lblWashIron.minimumScaleFactor = 0.5
        
        let attrKeyIroning = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrIroning = NSAttributedString(string: "IRONING", attributes: attrKeyIroning)
        
        lblIroning.attributedText = attrIroning
        lblIroning.minimumScaleFactor = 0.5
        
        let attrKeyBags = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrBags = NSAttributedString(string: "BAGS", attributes: attrKeyBags)
        
        lblBags.attributedText = attrBags
        lblBags.minimumScaleFactor = 0.5
        
        let attrKeyShoes = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrShoes = NSAttributedString(string: "SHOES", attributes: attrKeyShoes)
        
        lblShoes.attributedText = attrShoes
        lblShoes.minimumScaleFactor = 0.5
        
        let attrKeyLeather = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrLeather = NSAttributedString(string: "LEATHER", attributes: attrKeyLeather)
        
        lblLeather.attributedText = attrLeather
        lblLeather.minimumScaleFactor = 0.5
        
        let attrKeyCurtain = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrCurtain = NSAttributedString(string: "CURTAINS", attributes: attrKeyCurtain)
        
        lblCurtain.attributedText = attrCurtain
        lblCurtain.minimumScaleFactor = 0.5
        
        let attrKeyCarpet = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
        let attrCarpet = NSAttributedString(string: "CARPET", attributes: attrKeyCarpet)
        
        lblCarpet.attributedText = attrCarpet
        lblCarpet.minimumScaleFactor = 0.5
        
        
        let newTopConstraint = self.topGradientMultiplierConstraint.constraintWithMultiplier(0.28)
        self.view!.removeConstraint(self.topGradientMultiplierConstraint)
        self.view!.addConstraint(newTopConstraint)
        self.topGradientMultiplierConstraint = newTopConstraint
        
        
        let newBottomConstraint = self.bottomGradientMultiplierConstraint.constraintWithMultiplier(0.7)
        self.view!.removeConstraint(self.bottomGradientMultiplierConstraint)
        self.view!.addConstraint(newBottomConstraint)
        self.bottomGradientMultiplierConstraint = newBottomConstraint
        
        self.view!.layoutIfNeeded()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == scrollViewServices {
            let page = scrollView.contentOffset.x/view.frame.size.width
            
            print("page: \(page)")
            
            scrollViewServicesTitle.contentOffset.x =  (-view.frame.size.width * 0.17) + (scrollView.contentOffset.x * 0.65)
        }
    }
    
    @IBAction func btnDryCleaningPressed(_ sender: UIButton) {
        
        if !sender.isSelected {
            
            sender.isSelected = true
            
            greenDCTSTackView.axis = .vertical
            greenDCTSTackView.spacing = -4
            greenDCTSTackView.alignment = .center
            
            if greenDCTSTackView.subviews.count == 0
            {
                let btnGreenDC = UIButton(type: .custom)
                btnGreenDC.setImage(UIImage.init(named: "wash_iron"), for: .normal)
                btnGreenDC.imageView!.contentMode = .scaleAspectFit
                
                let lblGreenDC = UILabel()
                let attrKeyIroning = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-7)!, NSAttributedStringKey.kern: NSNumber(value: 0.5)]
                let attrIroning = NSAttributedString(string: "Green DryCleaning".uppercased(), attributes: attrKeyIroning)
                
                lblGreenDC.attributedText = attrIroning
                lblGreenDC.minimumScaleFactor = 0.5
                
                greenDCTSTackView.addArrangedSubview(btnGreenDC)
                greenDCTSTackView.addArrangedSubview(lblGreenDC)
                
                self.personalCareStackView.insertArrangedSubview(greenDCTSTackView, at: 2)
                greenDCTSTackView.isHidden = true
                
                let insets:CGFloat = 3
                btnGreenDC.imageEdgeInsets = .init(top: insets, left: insets, bottom: insets, right: insets)
            }
            
            let newConstraint = self.personalCaremultiplier.constraintWithMultiplier(0.73)
            self.view!.removeConstraint(self.personalCaremultiplier)
            self.view!.addConstraint(newConstraint)
            self.personalCaremultiplier = newConstraint
            self.view!.layoutIfNeeded()
//
            let insets:CGFloat = 3
            dryCleaningBtn.imageEdgeInsets = .init(top: insets, left: insets, bottom: insets, right: insets)
            
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
            
            dryCleaningBtn.imageEdgeInsets = .zero
            
            let newConstraint = self.personalCaremultiplier.constraintWithMultiplier(0.96)
            self.view!.removeConstraint(self.personalCaremultiplier)
            self.view!.addConstraint(newConstraint)
            self.personalCaremultiplier = newConstraint
            self.view!.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.loadWashStackView.isHidden = false
                self.washIronStackView.isHidden = false
                self.ironingStackView.isHidden = false
                
                self.greenDCTSTackView.isHidden = true
                
                
            }) { (success) in
                
            }
        }
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

