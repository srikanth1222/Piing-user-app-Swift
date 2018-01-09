//
//  AddAddressViewController.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 30/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController, UITextFieldDelegate {
    
    let selectedBorderWidth = CGFloat(1.3)
    let borderWidth = CGFloat(1.0)
    let duration = 0.2
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            let attrString = AppDelegate.getAttributedString("SAVE", spacing: 1.5)
            saveButton.setAttributedTitle(attrString, for: .normal)
        }
    }
    
    @IBOutlet weak var addAddressView: UIView!
    
    @IBOutlet weak var scrollViewTextFields: UIScrollView!
    
    @IBOutlet weak var scrollViewBottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblAddAddress: UILabel! {
        didSet {
            lblAddAddress.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE)
        }
    }
    
    var postalCodeString = String("")
    
    @IBOutlet weak var postalCodeTextField: UITextField! {
        didSet {
            postalCodeTextField.backgroundColor = .clear
            postalCodeTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-3)
            postalCodeTextField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var buildingNameTextField: UITextField! {
        didSet {
            buildingNameTextField.backgroundColor = .clear
            buildingNameTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-3)
            buildingNameTextField.isEnabled = false
        }
    }
    
    @IBOutlet weak var floorNoTextField: UITextField! {
        didSet {
            floorNoTextField.backgroundColor = .clear
            floorNoTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-3)
        }
    }
    
    @IBOutlet weak var unitNoTextField: UITextField! {
        didSet {
            unitNoTextField.backgroundColor = .clear
            unitNoTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-3)
        }
    }
    
    @IBOutlet weak var saveAsTextField: UITextField! {
        didSet {
            saveAsTextField.backgroundColor = .clear
            saveAsTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-3)
            saveAsTextField.isEnabled = false
        }
    }
    
    @IBOutlet weak var additionalNotesTextField: UITextField! {
        didSet {
            additionalNotesTextField.backgroundColor = .clear
            additionalNotesTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-3)
        }
    }
    
    @IBOutlet weak var otherTextFieldsStackView: UIStackView! {
        didSet {
            otherTextFieldsStackView.isHidden = true
        }
    }
    
    @IBOutlet var lblTitlesForTextFileds: [UILabel]!
    
    var customMapView: CustomMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for lbl in lblTitlesForTextFileds {
            lbl.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)
        }

        perform(#selector(addBottomLineForAllTextFields), with: nil, afterDelay: 0.3)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        customMapView = CustomMapView(frame: CGRect(x: 0.0, y: 0, width: self.view.frame.size.width, height: addAddressView.frame.size.height))
        self.view.addSubview(customMapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.sendSubview(toBack: customMapView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.customMapView.frame = CGRect(x: 0.0, y: 0, width: self.view.frame.size.width, height: self.addAddressView.frame.minY)
        }) { (completed) in
            
        }
        
        scrollViewTextFields.contentSize = CGSize(width: scrollViewTextFields.frame.size.width, height: scrollViewTextFields.frame.size.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func addBottomLineForAllTextFields() {
        
        addBottomLineForTextField(postalCodeTextField)
        addBottomLineForTextField(buildingNameTextField)
        addBottomLineForTextField(floorNoTextField)
        addBottomLineForTextField(unitNoTextField)
        addBottomLineForTextField(saveAsTextField)
        addBottomLineForTextField(additionalNotesTextField)
    }
    
    func addBottomLineForTextField(_ textField: UITextField) {
        
        textField.backgroundColor = .clear
        textField.delegate = self
        
        let bottomLineForEmail = CALayer()
        bottomLineForEmail.borderWidth = borderWidth
        bottomLineForEmail.borderColor = UIColor.lightGray.cgColor
        bottomLineForEmail.frame = CGRect(x: 0, y: textField.frame.size.height - borderWidth, width: textField.frame.size.width, height: borderWidth)
        textField.layer.addSublayer(bottomLineForEmail)
        textField.layer.masksToBounds = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let allLayers = textField.layer.sublayers!
        
        var bottomLayer:CALayer? = nil
        
        for layer in allLayers {
            
            if layer.frame.size.height == borderWidth {
                
                bottomLayer = layer
            }
        }
        
        let bottomLine = CALayer()
        bottomLine.borderWidth = selectedBorderWidth
        bottomLine.borderColor = AppColors.blueColor.cgColor
        textField.layer.addSublayer(bottomLine)
        textField.layer.masksToBounds = true
        //bottomLine.anchorPoint = CGPoint(x: 0, y: 1)
        
        let oldBounds = CGRect(x: 0, y: textField.frame.size.height - selectedBorderWidth, width: 0, height: selectedBorderWidth)
        let newBounds = CGRect(x: 0, y: textField.frame.size.height - selectedBorderWidth, width: textField.frame.size.width, height: selectedBorderWidth)
        
        let basicAnimation = CABasicAnimation(keyPath: "bounds")
        basicAnimation.fromValue = NSValue.init(cgRect: oldBounds)
        basicAnimation.toValue = NSValue.init(cgRect: newBounds)
        basicAnimation.duration = duration
        
        bottomLine.add(basicAnimation, forKey: "bounds")
        
        bottomLine.frame = CGRect(x: 0, y: textField.frame.size.height - selectedBorderWidth, width: textField.frame.size.width, height: selectedBorderWidth)
        
        self.perform(#selector(removePreviousLayer(_:)), with: bottomLayer, afterDelay: duration)
    }
    
    @objc func removePreviousLayer(_ bottomLayer: CALayer) {
        
        bottomLayer.removeFromSuperlayer()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let allLayers = textField.layer.sublayers!
        
        var bottomLayer:CALayer? = nil
        
        for layer in allLayers {
            
            if layer.frame.size.height == selectedBorderWidth {
                
                bottomLayer = layer
            }
        }
        
        let bottomLine = CALayer()
        bottomLine.borderWidth = borderWidth
        bottomLine.borderColor = UIColor.lightGray.cgColor
        textField.layer .addSublayer(bottomLine)
        textField.layer.masksToBounds = true
        bottomLine.frame = CGRect(x: 0, y: textField.frame.size.height - borderWidth, width: textField.frame.size.width, height: borderWidth)
        bottomLine.opacity = 0.0
        
        let basicAnimation = CABasicAnimation(keyPath: "opacity")
        basicAnimation.fromValue = 0.0
        basicAnimation.toValue = 1.0
        basicAnimation.duration = duration
        
        bottomLine.add(basicAnimation, forKey: "opacity")
        
        bottomLine.opacity = 1.0
        
        self.perform(#selector(removePreviousLayer(_:)), with: bottomLayer, afterDelay: duration)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == postalCodeTextField {
            if let text = textField.text as NSString? {
                postalCodeString = text.replacingCharacters(in: range, with: string)
            }
            
            if postalCodeString.count == 6 {
                textField.text = postalCodeString
                textField.resignFirstResponder()
                
                checkPostalcCodeValid()
                
                return false
            }
            else if postalCodeString.count > 6 {
                return false
            }
            else if postalCodeString.count < 6 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.otherTextFieldsStackView.alpha = 0.0
                }, completion: { (comepleted) in
                    self.otherTextFieldsStackView.isHidden = true
                })
                
                return true
            }
        }
        
        return true
    }
    
    func checkPostalcCodeValid() {
        
        let dictPrams: [String:Any] = ["zipcode" : postalCodeString]
        
        let URLString = WebServices.BASE_URL+WebServices.POSTALCODE_SERVICEABLE
        
        WebServices.serviceCall(withURLString: URLString, parameters: dictPrams, completionHandler: {(error, responseObject, data) in
            
            guard let responseObject = responseObject else { return }
            
            print (responseObject)
            
            guard let data = data else { return }
            
            do {
                
                let responseObject = try JSONDecoder().decode(ResponseModel.self, from: data)
                
                print (responseObject)
                
                self.buildingNameTextField.text = ""
                self.saveAsTextField.text = ""
                
                if responseObject.s == 100 {
                    AppDelegate.logoutFromTheApp()
                    return
                }
                else if responseObject.s == 0 {
                    AppDelegate.showAlertViewWith(message: responseObject.error!, title: "", actionTitle: "OK")
                    self.customMapView.clearAllMarkers()
                }
                else if responseObject.s == 1 {
                    self.otherTextFieldsStackView.isHidden = false
                    self.otherTextFieldsStackView.alpha = 0.0
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.otherTextFieldsStackView.alpha = 1.0
                    }, completion: { (comepleted) in
                    })
                    
                    if responseObject.address?.building == "." {
                        self.buildingNameTextField.text = responseObject.address?.region
                    }
                    else {
                        self.buildingNameTextField.text = responseObject.address?.building
                    }
                    self.saveAsTextField.text = responseObject.address?.street
                    
                    self.updateMapView(with: responseObject.address!)
                }
            }
            catch let jsonDecodeErr {
                
                print("Error while parsing Valid Postal code: \(jsonDecodeErr)")
            }
        })
    }
    
    func updateMapView(with validPostalCodeModel:ValidPostalCodeModel) {
        customMapView.clearAllMarkers()
        customMapView.showCustomerMarkerOnTheMap(with: Double(validPostalCodeModel.lat!)!, longitude: Double(validPostalCodeModel.lon!)!)
        customMapView.focusMapToShowAllMarkers()
    }
    
    @objc func keyboardWillChange(_ notif:Notification) {
        
        guard let userInfo = notif.userInfo else { return }
        
        print(userInfo)
        
        //print ("From bottom : \(self.scrollViewBottomSpaceConstraint.constant)")
        
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]  as! TimeInterval
        
        var scrollViewHeight = self.view.frame.size.height - (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.origin.y
        
        if #available(iOS 11.0, *) {

            if scrollViewHeight == 0 {
            }
            else {
                scrollViewHeight = scrollViewHeight - view.safeAreaInsets.bottom
            }

        } else {
            // Fallback on earlier versions
        }
        
        scrollViewHeight = scrollViewHeight - saveButton.frame.size.height
        
        self.scrollViewBottomSpaceConstraint.constant = scrollViewHeight
        
        UIView.animate(withDuration: duration, animations: {

            self.view.layoutIfNeeded()

        }) { (success) in
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
