//
//  WelcomeScreenViewController.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 30/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit
import AVKit


class WelcomeScreenViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView! {
        didSet {
            
            bottomView.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
            blurredEffectView.alpha = 1.0
//            blurredEffectView.frame = bottomView.bounds
//            blurredEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
            bottomView.insertSubview(blurredEffectView, at: 0)
            
//            // Get the superview's layout
//            let margins = bottomView.layoutMarginsGuide
//
//            blurredEffectView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
//            blurredEffectView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
//            blurredEffectView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
//            blurredEffectView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
            
            
            NSLayoutConstraint(item: blurredEffectView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: bottomView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: blurredEffectView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: bottomView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: blurredEffectView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: bottomView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: blurredEffectView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: bottomView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0).isActive = true
            
        }
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        
        didSet{
            signupButton.titleLabel?.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-3)
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        
        didSet {
            
            loginButton.titleLabel?.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-3)
            loginButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var personTypeView: UIView!
    
    @IBOutlet weak var personTypeBottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton! {
        
        didSet {
            
            nextButton.titleLabel?.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-3)
            nextButton.imageView?.contentMode = .scaleAspectFit
            nextButton.isEnabled(false)
        }
    }
    
    @IBOutlet weak var backButton: UIButton! {
        
        didSet {
            
            backButton.titleLabel?.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-3)
            backButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var lblResident: UILabel! {
        didSet{
            lblResident.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-3)
        }
    }
    
    @IBOutlet weak var lblTourist: UILabel! {
        didSet{
            lblTourist.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-3)
        }
    }
    
    @IBOutlet weak var lblWho: UILabel! {
        didSet{
            lblWho.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE)
        }
    }
    
    @IBOutlet weak var residentButton: UIButton!
    @IBOutlet weak var touristButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        guard let filePath = Bundle.main.path(forResource: "intra_video", ofType: "mp4") else { return }
        
        let player = AVPlayer(url: URL(fileURLWithPath: filePath))
        
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
        
        let viewTransperent = UIView(frame: self.view.bounds)
        viewTransperent.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.insertSubview(viewTransperent, at: 1)
        
        nextButton.imageEdgeInsets = UIEdgeInsetsMake(AppDelegate.SCREEN_WIDTH * 0.06, 0, AppDelegate.SCREEN_WIDTH * 0.06, 0)
        nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -AppDelegate.SCREEN_WIDTH * 0.03)
        
        backButton.imageEdgeInsets = UIEdgeInsetsMake(AppDelegate.SCREEN_WIDTH * 0.06, 0, AppDelegate.SCREEN_WIDTH * 0.06, 0)
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -AppDelegate.SCREEN_WIDTH * 0.03, 0, 0)
        
        personTypeBottomSpaceConstraint.constant = self.view.frame.size.height
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        personTypeBottomSpaceConstraint.constant = self.view.frame.size.height
//    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var viewTransperent = UIView()
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        
        viewTransperent = UIView(frame: self.view.bounds)
        view.insertSubview(viewTransperent, belowSubview: personTypeView)
        self.viewTransperent.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.viewTransperent.alpha = 0.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnPersonTypeView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.viewTransperent.addGestureRecognizer(tapGesture)
        
        personTypeBottomSpaceConstraint.constant = 0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.viewTransperent.alpha = 1.0
        }) { (comepleted) in
            
        }
    }
    
    @objc func tappedOnPersonTypeView() {
        
        let btn = UIButton()
        backButtonPressed(btn)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        personTypeBottomSpaceConstraint.constant = self.view.frame.size.height
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.viewTransperent.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { (comepleted) in
            
            self.viewTransperent.removeFromSuperview()
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        guard let registrationVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController else { return }
        
        if residentButton.isSelected {
            registrationVC.personType = "R"
        }
        else {
            registrationVC.personType = "T"
        }
        
        UIView.transition(with: self.navigationController!.view, duration: 0.6, options: .transitionFlipFromRight, animations: {
            
            self.navigationController?.pushViewController(registrationVC, animated: false)
            
        }) { (comepleted) in
            
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let loginVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        
        UIView.transition(with: self.navigationController!.view, duration: 0.6, options: .transitionFlipFromRight, animations: {
        
            self.navigationController?.pushViewController(loginVC, animated: false)
            
        }) { (comepleted) in
            
        }
    }
    
    @IBAction func onPersonTypePressed(_ sender: UIButton) {
        
        nextButton.isEnabled(true)
        
        residentButton.isSelected = false
        touristButton.isSelected = false
        
        if sender.tag == 1 {
            residentButton.isSelected = true
        }
        else {
            touristButton.isSelected = true
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
