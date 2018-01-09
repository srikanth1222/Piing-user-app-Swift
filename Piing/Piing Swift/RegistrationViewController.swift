//
//  RegistrationViewController.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 03/01/18.
//  Copyright © 2018 Piing. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    let selectedBorderWidth = CGFloat(1.3)
    let borderWidth = CGFloat(1.0)
    let duration = 0.2
    
    @IBOutlet weak var nextButton: UIButton!
    
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
    
    @IBOutlet weak var nameViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneViewLeadingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblYourName: UILabel! {
        didSet {
            lblYourName.font = UIFont.init(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE)
        }
    }
    
    @IBOutlet weak var lblLogin: UILabel! {
        didSet {
            lblLogin.font = UIFont.init(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE)
        }
    }
    @IBOutlet weak var lblPhone: UILabel! {
        didSet {
            lblPhone.font = UIFont.init(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE)
        }
    }
    
    @IBOutlet weak var firstNameTextField: UITextField! {
        didSet{
            firstNameTextField.backgroundColor = .clear
            firstNameTextField.text = ""
            firstNameTextField.delegate = self
            firstNameTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-1)
            
            let placeHolder = "First name"
            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)!])
            
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
            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)!])
            
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
            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)!])
            
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
            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)!])
            
            passwordTextField.attributedPlaceholder = attrPlaceHolder
        }
    }
    
    @IBOutlet weak var phoneTextField: UITextField! {
        didSet{
            phoneTextField.backgroundColor = .clear
            phoneTextField.text = ""
            phoneTextField.delegate = self
            phoneTextField.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-1)
            
            let placeHolder = "+65"
            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)!])
            
            phoneTextField.attributedPlaceholder = attrPlaceHolder
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.imageEdgeInsets = UIEdgeInsetsMake(view.frame.size.height * 0.02, 0, view.frame.size.height * 0.02, 0)
        
        perform(#selector(addBottomLineForAllTextFields), with: nil, afterDelay: 0.3)
    }
    
    @objc func addBottomLineForAllTextFields() {
        
        nameViewTopConstraint.constant = AppDelegate.SCREEN_HEIGHT * 0.1 + AppDelegate.safeAreaTopInset()
        emailViewTopConstraint.constant = AppDelegate.SCREEN_HEIGHT * 0.1 + AppDelegate.safeAreaTopInset()
        phoneViewTopConstraint.constant = AppDelegate.SCREEN_HEIGHT * 0.1 + AppDelegate.safeAreaTopInset()
        
        emailViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH
        phoneViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH * 2
        
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
        
        if textField != firstNameTextField, textField != lastNameTextField, string == " " {
            return false
        }
        
//        if textField == emailTextField {
//            if let text = textField.text as NSString? {
//                emailString = text.replacingCharacters(in: range, with: string)
//            }
//        }
//
//        if textField == passwordTextField {
//            if let text = textField.text as NSString? {
//                passwordString = text.replacingCharacters(in: range, with: string)
//            }
//        }
//
//        if textField.text?.count == 0, passwordFirstCharacterAfterDidBeginEditing {
//            passwordFirstCharacterAfterDidBeginEditing = false
//        }
//
//        if textField == passwordTextField, textField.text!.count > 0, passwordFirstCharacterAfterDidBeginEditing, string == ""   {
//            // Deleting all characters
//            passwordString = ""
//            passwordTextField.text = ""
//        }
        
        
        if textField == passwordTextField, textField.text!.count > 19  {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if nameViewLeadingConstraint.constant == 0 {
            nameViewLeadingConstraint.constant = -AppDelegate.SCREEN_WIDTH
            emailViewLeadingConstraint.constant = 0
            phoneViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH
        }
        else if emailViewLeadingConstraint.constant == 0 {
            nameViewLeadingConstraint.constant = -(AppDelegate.SCREEN_WIDTH * 2)
            emailViewLeadingConstraint.constant = -AppDelegate.SCREEN_WIDTH
            phoneViewLeadingConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }) { (comepleted) in
            
        }
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
        }
        else if phoneViewLeadingConstraint.constant == 0 {
            nameViewLeadingConstraint.constant = -AppDelegate.SCREEN_WIDTH
            emailViewLeadingConstraint.constant = 0
            phoneViewLeadingConstraint.constant = AppDelegate.SCREEN_WIDTH
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }) { (comepleted) in
            
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
