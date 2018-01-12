//
//  RegistrationViewController.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 03/01/18.
//  Copyright © 2018 Piing. All rights reserved.
//

import UIKit
import KWVerificationCodeView


class RegistrationViewController: UIViewController, UITextFieldDelegate, KWVerificationCodeViewDelegate {
    
    func didChangeVerificationCode() {
        nextButton.isEnabled(verificationCustomView.hasValidCode())
    }
    
    let selectedBorderWidth = CGFloat(1.3)
    let borderWidth = CGFloat(1.0)
    let duration = 0.2
    
    var personType: String = ""
    
    @IBOutlet weak var nextButton: UIButton! {
        
        didSet {
            
            nextButton.titleLabel?.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-2)
            nextButton.imageView?.contentMode = .scaleAspectFit
            nextButton.isEnabled(false)
        }
    }
    
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton! {
        
        didSet {
            backButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var nameView: UIView! {
        didSet{
            nameView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var emailView: UIView!  {
        didSet{
            emailView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var phoneView: UIView! {
        didSet{
            phoneView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var verificationView: UIView! {
        didSet{
            verificationView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var nameViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var verificationViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var verificationViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblYourName: UILabel! {
        didSet {
            lblYourName.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE)
        }
    }
    
    @IBOutlet weak var lblLogin: UILabel! {
        didSet {
            lblLogin.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE)
        }
    }
    @IBOutlet weak var lblPhone: UILabel! {
        didSet {
            lblPhone.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE)
        }
    }
    
    @IBOutlet weak var firstNameTextField: UITextField! {
        didSet{
            firstNameTextField.backgroundColor = .clear
            firstNameTextField.text = ""
            firstNameTextField.delegate = self
            firstNameTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-1)
            
            let placeHolder = "First name"
            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)!])
            
            firstNameTextField.attributedPlaceholder = attrPlaceHolder
        }
    }
    
    @IBOutlet weak var lastNameTextField: UITextField! {
        didSet{
            lastNameTextField.backgroundColor = .clear
            lastNameTextField.text = ""
            lastNameTextField.delegate = self
            lastNameTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-1)
            
            let placeHolder = "Last name"
            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)!])
            
            lastNameTextField.attributedPlaceholder = attrPlaceHolder
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet{
            emailTextField.backgroundColor = .clear
            emailTextField.text = ""
            emailTextField.delegate = self
            emailTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-1)
            
            let placeHolder = "Email address"
            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)!])
            
            emailTextField.attributedPlaceholder = attrPlaceHolder
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet{
            passwordTextField.backgroundColor = .clear
            passwordTextField.text = ""
            passwordTextField.delegate = self
            passwordTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-1)
            
            let placeHolder = "Password"
            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)!])
            
            passwordTextField.attributedPlaceholder = attrPlaceHolder
        }
    }
    
    @IBOutlet weak var phoneTextField: UITextField! {
        didSet{
            phoneTextField.backgroundColor = .clear
            //phoneTextField.text = ""
            phoneTextField.delegate = self
            phoneTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-1)
            
            phoneNumberString = "+65 "
            
//            let placeHolder = "+65"
//            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)!])
//
//            phoneTextField.attributedPlaceholder = attrPlaceHolder
        }
    }
    
    @IBOutlet weak var lblEnterDigits: UILabel! {
        didSet {
            lblEnterDigits.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var lblResendCode: UILabel! {
        didSet {
            lblResendCode.font = UIFont.init(name: AppFont.APPFONT_LIGHT, size: AppDelegate.GLOBAL_FONT_SIZE-5)
        }
    }
    
    @IBOutlet weak var verificationCustomView: KWVerificationCodeView! {
        didSet {
            verificationCustomView.delegate = self
            verificationCustomView.digits = 6
            verificationCustomView.textSize = AppDelegate.GLOBAL_FONT_SIZE+3
            verificationCustomView.textFont = AppFont.APPFONT_BOLD
            verificationCustomView.textColor = .black
            verificationCustomView.underlineColor = .gray
            verificationCustomView.underlineSelectedColor = AppColors.blueColor
            verificationCustomView.backgroundColor = .clear
            verificationCustomView.darkKeyboard = true
        }
    }
    
    var firstNameString = ""
    var lastNameString = ""
    var phoneNumberString = ""
    var emailString = ""
    var passwordString = ""
    var verificationCodeString = ""
    var passwordFirstCharacterAfterDidBeginEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
        
        perform(#selector(addBottomLineForAllTextFields), with: nil, afterDelay: 0.3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.imageEdgeInsets = UIEdgeInsetsMake(AppDelegate.SCREEN_WIDTH * 0.045, 0, AppDelegate.SCREEN_WIDTH * 0.045, AppDelegate.SCREEN_WIDTH * 0.03)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func addBottomLineForAllTextFields() {
        
        nameViewTopConstraint.constant = AppDelegate.SCREEN_HEIGHT * 0.1
        emailViewTopConstraint.constant = AppDelegate.SCREEN_HEIGHT * 0.1
        phoneViewTopConstraint.constant = AppDelegate.SCREEN_HEIGHT * 0.1
        verificationViewTopConstraint.constant = AppDelegate.SCREEN_HEIGHT * 0.1
        
        emailViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH
        phoneViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH * 2
        verificationViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH * 3
        
        addBottomLineForTextField(firstNameTextField)
        addBottomLineForTextField(lastNameTextField)
        addBottomLineForTextField(emailTextField)
        addBottomLineForTextField(passwordTextField)
        addBottomLineForTextField(phoneTextField)
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
    
    
    @objc func keyboardWillChange(_ notif:Notification) {
        
        guard let userInfo = notif.userInfo else { return }
        
        print(userInfo)
        
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]  as! TimeInterval
        
        let originY = self.view.frame.size.height - (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.origin.y
        
        if #available(iOS 11.0, *) {
            
            if originY == 0 {
                self.nextButtonBottomConstraint.constant = originY
            }
            else {
                self.nextButtonBottomConstraint.constant = originY - view.safeAreaInsets.bottom
            }
            
        } else {
            // Fallback on earlier versions
            self.nextButtonBottomConstraint.constant = originY
        }
        
        UIView.animate(withDuration: duration, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (success) in
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let allLayers = textField.layer.sublayers!
        
        var bottomLayer:CALayer? = nil
        
        for layer in allLayers {
            
            if layer.frame.size.height == borderWidth {
                
                bottomLayer = layer
                break
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
        
        if textField == firstNameTextField {
            if firstNameString == "", lastNameString == "" {
                nextButton.isEnabled(false)
            }
            else {
                nextButton.isEnabled(true)
            }
        }
        else if textField == emailTextField {
            if emailString == "", passwordString == "" {
                nextButton.isEnabled(false)
            }
            else {
                nextButton.isEnabled(true)
            }
        }
        else if textField == phoneTextField {
            if phoneNumberString.count < 12 {
                nextButton.isEnabled(false)
            }
            else {
                nextButton.isEnabled(true)
            }
        }
        else if textField == passwordTextField {
            passwordFirstCharacterAfterDidBeginEditing = true
        }
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
                break
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
        
        if textField != firstNameTextField, textField != lastNameTextField, string == " " {
            return false
        }
        
        if firstNameString == "", lastNameString == "", string == " " {
            return false
        }
        
        if (firstNameString.hasSuffix(" ") || lastNameString.hasSuffix(" ")), string == " " {
            return false
        }
        
        if textField == firstNameTextField {
            if let text = textField.text as NSString? {
                firstNameString = text.replacingCharacters(in: range, with: string)
            }
        }
        
        if textField == lastNameTextField {
            if let text = textField.text as NSString? {
                lastNameString = text.replacingCharacters(in: range, with: string)
            }
        }
        
        if textField == emailTextField {
            if let text = textField.text as NSString? {
                emailString = text.replacingCharacters(in: range, with: string)
            }
        }
        
        if textField == passwordTextField {
            if let text = textField.text as NSString?, (textField.text!.count < 20 || string == "") {
                passwordString = text.replacingCharacters(in: range, with: string)
            }
            else {
                return false
            }
        }
        
        if textField.text?.count == 0, passwordFirstCharacterAfterDidBeginEditing {
            passwordFirstCharacterAfterDidBeginEditing = false
        }
        
        if textField == passwordTextField, textField.text!.count > 0, passwordFirstCharacterAfterDidBeginEditing, string == ""   {
            // Deleting all characters
            passwordString = ""
            passwordTextField.text = ""
        }
        
        if textField == phoneTextField {
            if let text = textField.text as NSString? {
                if string == "", phoneNumberString == "+65 " {
                    return false
                }
                else if phoneNumberString.count == 12, string != "" {
                    nextButton.isEnabled(true)
                    return false
                }
                else {
                    nextButton.isEnabled(false)
                }
                
                phoneNumberString = text.replacingCharacters(in: range, with: string)
            }
        }
        
        if firstNameString != "", lastNameString != "", nameViewLeadingConstraint.constant == 0 {
            nextButton.isEnabled(true)
        }
        else if emailString != "", passwordString.count >= 6, emailViewLeadingConstraint.constant == 0 {
            nextButton.isEnabled(true)
        }
        else if phoneNumberString.count == 12, phoneViewLeadingConstraint.constant == 0 {
            nextButton.isEnabled(true)
        }
        else if verificationCodeString.count == 6, verificationViewLeadingConstraint.constant == 0 {
            nextButton.isEnabled(true)
        }
        else {
            nextButton.isEnabled(false)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        }
        else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if nameViewLeadingConstraint.constant == 0 {
            nameViewLeadingConstraint.constant = -AppDelegate.SCREEN_WIDTH
            emailViewLeadingConstraint.constant = 0
            phoneViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH
            verificationViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH * 2
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }) { (comepleted) in
                self.emailTextField.becomeFirstResponder()
            }
        }
        else if emailViewLeadingConstraint.constant == 0 {
            
            if AppDelegate.validateEmail(emailString, with: AppDelegate.VALIDATE_EMAILID) {
                
                if personType == "R" {
                    nameViewLeadingConstraint.constant = -(AppDelegate.SCREEN_WIDTH * 2)
                    emailViewLeadingConstraint.constant = -AppDelegate.SCREEN_WIDTH
                    phoneViewLeadingConstraint.constant = 0
                    verificationViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.view.layoutIfNeeded()
                        self.nextButton.setTitle("SEND OTP", for: .normal)
                    }) { (comepleted) in
                        self.phoneTextField.becomeFirstResponder()
                    }
                }
                else {
                    
                }
            }
            else {
                AppDelegate.showAlertViewWith(message: "Please enter valid email id.", title: "", actionTitle: "OK")
            }
        }
        else if phoneViewLeadingConstraint.constant == 0 {
            nameViewLeadingConstraint.constant = -(AppDelegate.SCREEN_WIDTH * 3)
            emailViewLeadingConstraint.constant = -(AppDelegate.SCREEN_WIDTH * 2)
            phoneViewLeadingConstraint.constant = -AppDelegate.SCREEN_WIDTH
            verificationViewLeadingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                self.nextButton.setTitle("NEXT", for: .normal)
            }) { (comepleted) in
                
                self.phoneTextField.resignFirstResponder()
                self.nextButton.isEnabled(self.verificationCustomView.hasValidCode())
                
                self.prepareLabelPhoneNumber()
            }
        }
        else {
            
            registrationServiceCalled()
        }
    }
    
    func prepareLabelPhoneNumber() {
        
        let strDigit = "Enter the 6 digit code sent to "
        let strNumber = self.phoneNumberString
        
        let attrKeyDigit = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE)!, NSAttributedStringKey.kern: NSNumber(value: 1.0)]
        let attrKeyPhone = [NSAttributedStringKey.foregroundColor : AppColors.blueColor, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE)!, NSAttributedStringKey.kern: NSNumber(value: 1.0)]
        
        let attrDigit = NSMutableAttributedString(string: strDigit, attributes: attrKeyDigit)
        let attrPhoneNumber = NSMutableAttributedString(string: strNumber, attributes: attrKeyPhone)
        
        attrDigit.append(attrPhoneNumber)
        
        self.lblEnterDigits.attributedText = attrDigit
    }
    
    func registrationServiceCalled() {
        
        //    NSDictionary *dictReg = [NSMutableDictionary dictionaryWithObjectsAndKeys:registerFeilds.emailAddress, @"email", registerFeilds.password, @"password", registerFeilds.firstName,@"name", registerFeilds.cellPhone, @"phone", @"IOS", @"source", registerFeilds.referalCode, @"referCode", registerFeilds.extn_Number, @"roomExtensionNo", [[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST], @"userType", @"000000", @"zipcode", nil];
        
        
        let dictPrams:[String:Any] = ["email" : emailString, "password" : passwordString, "firstname" : firstNameString, "lastname" : lastNameString, "phone" : phoneNumberString, "source" : "IOS", "referCode" : "", "userType" : "", "zipcode" : "000000", "roomExtensionNo" : ""]
        
        let loginService = WebServices.BASE_URL+WebServices.LOGIN_SERVICE
        WebServices.serviceCall(withURLString: loginService, parameters: dictPrams, completionHandler: { (error, responseObject, data) in
            
            guard let responseObject = responseObject else { return }
            
            print (responseObject)
            
            guard let data = data else { return }
            
            do {
                
                let loginData = try JSONDecoder().decode(LoginModel.self, from: data)
                print(loginData)
                
                if loginData.s == 1 {
                    
                    UserDefaults.standard.set(loginData.uid, forKey: "uid")
                    UserDefaults.standard.set(loginData.t, forKey: "token")
                    
                    AppDelegate.constantDictValues["uid"] = loginData.uid
                    AppDelegate.constantDictValues["t"] = loginData.t
                    
                    guard let homePageVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
                    self.navigationController?.pushViewController(homePageVC, animated: true)
                    
                    UserDefaults.standard.set(true, forKey: AppDelegate.IS_LOGIN_SUCCEDED)
                }
                else {
                    AppDelegate.showAlertViewWith(message: loginData.error!, title: "", actionTitle: "OK")
                }
            }
            catch let jsonErr {
                print(jsonErr)
            }
            
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        if nameViewLeadingConstraint.constant == 0 {
            
            UIView.transition(with: self.navigationController!.view, duration: 0.6, options: .transitionFlipFromLeft, animations: {
                
                self.navigationController?.popViewController(animated: false)
                
            }) { (comepleted) in
                
            }
        }
        else if emailViewLeadingConstraint.constant == 0 {
            nameViewLeadingConstraint.constant = 0
            emailViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH
            phoneViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH * 2
            verificationViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH * 3
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }) { (comepleted) in
                self.firstNameTextField.becomeFirstResponder()
            }
        }
        else if phoneViewLeadingConstraint.constant == 0 {
            nameViewLeadingConstraint.constant = -AppDelegate.SCREEN_WIDTH
            emailViewLeadingConstraint.constant = 0
            phoneViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH
            verificationViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH * 2
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                self.nextButton.setTitle("NEXT", for: .normal)
            }) { (comepleted) in
                self.emailTextField.becomeFirstResponder()
            }
        }
        else if verificationViewLeadingConstraint.constant == 0 {
            nameViewLeadingConstraint.constant = -(AppDelegate.SCREEN_WIDTH * 2)
            emailViewLeadingConstraint.constant = -AppDelegate.SCREEN_WIDTH
            phoneViewLeadingConstraint.constant = 0
            verificationViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                self.nextButton.setTitle("SEND OTP", for: .normal)
            }) { (comepleted) in
                self.phoneTextField.becomeFirstResponder()
            }
        }
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

extension UIButton {
    
    func isEnabled(_ isEnabled: Bool) {
        
        if isEnabled == true {
            self.isEnabled = true
            self.setTitleColor(UIColor.white, for: .normal)
        }
        else {
            self.isEnabled = false
            self.setTitleColor(UIColor.gray, for: .normal)
        }
    }
}




