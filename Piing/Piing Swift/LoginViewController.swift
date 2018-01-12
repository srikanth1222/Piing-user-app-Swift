//
//  LoginViewController.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 19/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit
import AVKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let selectedBorderWidth = CGFloat(2)
    let borderWidth = CGFloat(1.5)
    let duration = 0.2
    
    var emailString = ""
    var passwordString = ""
    
    var passwordFirstCharacterAfterDidBeginEditing = false
    
    @IBOutlet weak var gapOfLoginButtonFromBottom: NSLayoutConstraint!
    
    @IBOutlet weak var forgotPasswordButton: UIButton! {
        
        didSet {
            forgotPasswordButton.titleLabel?.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-4)
        }
    }
    
    @IBOutlet weak var backButton: UIButton! {
        
        didSet {
            backButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        
        didSet {
            
            loginButton.titleLabel?.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-2)
            loginButton.imageView?.contentMode = .scaleAspectFit
            loginButton.setTitleColor(UIColor.gray, for: .normal)
            loginButton.isEnabled = false
        }
    }
    
    
    @IBOutlet weak var verticalSpaceBtwLoginAndEmail: NSLayoutConstraint!
    @IBOutlet weak var verticalSpaceBtwEmailAndPassword: NSLayoutConstraint!
    
    @IBOutlet weak var lblLogIn: UILabel! {
        didSet {
            lblLogIn.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE+8)
        }
    }
    
    @IBOutlet weak var emailTF: UITextField! {
        
        didSet{
            self.emailTF.backgroundColor = .clear
            self.emailTF.text = ""
            self.emailTF.delegate = self
            self.emailTF.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE)
            
            let placeHolder = "Email address"
            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-2)!])
            
            self.emailTF.attributedPlaceholder = attrPlaceHolder
        }
    }
    
    @IBOutlet weak var passwordTF: UITextField! {
        
        didSet{
            self.passwordTF.backgroundColor = .clear
            self.passwordTF.text = ""
            self.passwordTF.delegate = self
            self.passwordTF.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE)
            
            let placeHolder = "Password"
            let attrPlaceHolder = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, .font : UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-2)!])
            
            self.passwordTF.attributedPlaceholder = attrPlaceHolder
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginButton.imageEdgeInsets = UIEdgeInsetsMake(AppDelegate.SCREEN_HEIGHT * 0.025, 0, AppDelegate.SCREEN_HEIGHT * 0.025, AppDelegate.SCREEN_WIDTH * 0.03)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let filePath = Bundle.main.path(forResource: "intra_video", ofType: "mp4") else { return }
        
        let player = AVPlayer(url: URL(fileURLWithPath: filePath))
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.view.addSubview(playerViewController.view)
//        playerViewController.view.frame = view.bounds
//        player.play()
        
        var playerLayer: AVPlayerLayer?
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer!.frame = self.view.frame
        view.layer.insertSublayer(playerLayer!, at: 0)
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: kCMTimeZero)
            player.play()
        }
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.alpha = 1.0
        blurredEffectView.frame = view.bounds
        playerLayer?.addSublayer(blurredEffectView.layer)
        view.insertSubview(blurredEffectView, at: 1)
        
        verticalSpaceBtwLoginAndEmail.constant = view.frame.size.height * 0.05
        verticalSpaceBtwEmailAndPassword.constant = view.frame.size.height * 0.1
        
        perform(#selector(addBottomLayerLineToTextFields), with: nil, afterDelay: 0.3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func addBottomLayerLineToTextFields() {
        
        let bottomLineForEmail = CALayer()
        bottomLineForEmail.borderWidth = borderWidth
        bottomLineForEmail.borderColor = UIColor.white.cgColor
        bottomLineForEmail.frame = CGRect(x: 0, y: self.emailTF.frame.size.height - borderWidth, width: self.emailTF.frame.size.width, height: borderWidth)
        self.emailTF.layer.addSublayer(bottomLineForEmail)
        self.emailTF.layer.masksToBounds = true
        
        
        let bottomLineForPwd = CALayer()
        bottomLineForPwd.borderWidth = borderWidth
        bottomLineForPwd.borderColor = UIColor.white.cgColor
        bottomLineForPwd.frame = CGRect(x: 0, y: self.passwordTF.frame.size.height - borderWidth, width: self.passwordTF.frame.size.width, height: borderWidth)
        self.passwordTF.layer.addSublayer(bottomLineForPwd)
        self.passwordTF.layer.masksToBounds = true
        
        self.emailTF.becomeFirstResponder()
    }
    
    @objc func keyboardWillChange(_ notif:Notification) {
        
        guard let userInfo = notif.userInfo else { return }
        
        print(userInfo)
        
        print ("From bottom : \(self.gapOfLoginButtonFromBottom.constant)")
        
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]  as! TimeInterval
        
        let originY = self.view.frame.size.height - (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.origin.y
        
        if #available(iOS 11.0, *) {
            
            if originY == 0 {
                self.gapOfLoginButtonFromBottom.constant = originY
            }
            else {
                self.gapOfLoginButtonFromBottom.constant = originY - view.safeAreaInsets.bottom
            }
            
        } else {
            // Fallback on earlier versions
            self.gapOfLoginButtonFromBottom.constant = originY
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
        
        if textField == passwordTF {
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
            }
        }
        
        let bottomLine = CALayer()
        bottomLine.borderWidth = borderWidth
        bottomLine.borderColor = UIColor.white.cgColor
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.emailTF {
            self.passwordTF.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        let cs = CharacterSet(charactersIn: AppDelegate.ACCEPTABLE_CHARECTERS).inverted
//        let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
//        return (string == filtered)
        
        if string == " " {
            return false
        }
        
        if textField == emailTF {
            if let text = textField.text as NSString? {
                emailString = text.replacingCharacters(in: range, with: string)
            }
        }
        
        if textField == passwordTF {
            if let text = textField.text as NSString? {
                passwordString = text.replacingCharacters(in: range, with: string)
            }
        }
        
        if textField.text?.count == 0, passwordFirstCharacterAfterDidBeginEditing {
            passwordFirstCharacterAfterDidBeginEditing = false
        }
        
        if textField == passwordTF, textField.text!.count > 0, passwordFirstCharacterAfterDidBeginEditing, string == ""   {
            // Deleting all characters
            passwordString = ""
            passwordTF.text = ""
        }
        
        if textField == passwordTF, textField.text!.count > 19  {
            return false
        }
        
        if emailString != "", passwordString != "" {
            loginButton.isEnabled = true
            loginButton.setTitleColor(UIColor.white, for: .normal)
        }
        else {
            loginButton.isEnabled = false
            loginButton.setTitleColor(UIColor.gray, for: .normal)
        }
        
        return true
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if AppDelegate.validateEmail(emailString, with: AppDelegate.VALIDATE_EMAILID)
        {
            print ("valid email")
            
            let dictPrams:[String:Any] = ["email" : emailString, "password" : passwordString]
            
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
        else {
            
            AppDelegate.showAlertViewWith(message: "Please enter valid email id.", title: "", actionTitle: "OK")
        }
    }
    
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        UIView.transition(with: self.navigationController!.view, duration: 0.6, options: .transitionFlipFromLeft, animations: {
            
            self.navigationController?.popViewController(animated: false)
            
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
