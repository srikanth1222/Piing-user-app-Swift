//
//  DealsViewController.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 23/01/18.
//  Copyright © 2018 Piing. All rights reserved.
//

import UIKit

// MARK: - State

private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

class DealsViewController: UIViewController {
    
    // MARK: - Constants
    
    @IBOutlet weak var backgroundViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewDeals: UITableView!
    @IBOutlet weak var tableViewBottomSpaceConstraint: NSLayoutConstraint!
    
    private lazy var bottomOffset: CGFloat = {
        let bottomOffset = self.mapVC.containerViewAvailableTime.frame.size.height + tabBar.frame.size.height
        return bottomOffset
    }()
    
    private lazy var topOffset: CGFloat = {
        let topOffset = self.view.frame.size.height - (constantTopOffset + AppDelegate.safeAreaTopInset() / 2.3)
        return topOffset
    }()
    
    private let scale: CGFloat = 0.93
    
    private lazy var topOffsetOfBackgroundView : CGFloat = {
        let topOffsetOfBackgroundView = AppDelegate.safeAreaTopInset() / 3
        return topOffsetOfBackgroundView
    }()
    
    private lazy var constantTopOffset : CGFloat = {
        let value = AppDelegate.SCREEN_WIDTH * 0.1
        return value
    }()
    
    // MARK: - Animation
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    private var currentState: State = .closed
    
    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var lblDeals: UILabel! {
        didSet {
            let attrKeyDeals = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE+8)!, NSAttributedStringKey.kern: NSNumber(value: 1.5)]
            let attrDeals = NSAttributedString(string: "Deals", attributes: attrKeyDeals)
            
            lblDeals.attributedText = attrDeals
        }
    }
    
    var mapVC = MapViewController()
    var homePageBottomConstraint = NSLayoutConstraint()
    var homePageHeightConstraint = NSLayoutConstraint()
    
    private lazy var tabBar: UITabBar = {
        
        let tabBar = self.tabBarController!.tabBar
        return tabBar
    }()
    
    
    private lazy var heightOfHomePage: CGFloat = {
       let height = view.frame.size.height - (constantTopOffset + AppDelegate.safeAreaTopInset() / 2.3)
        return height
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDeals.separatorStyle = .none
        
//        tableViewDeals.estimatedRowHeight = 250
//        tableViewDeals.rowHeight = UITableViewAutomaticDimension
        
        openHomePageController()
        
        tableViewBottomSpaceConstraint.constant = self.mapVC.containerViewAvailableTime.frame.size.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if currentState == .closed {
            bottomOffset = self.mapVC.containerViewAvailableTime.frame.size.height + tabBar.frame.size.height
            homePageBottomConstraint.constant = -bottomOffset
            
            heightOfHomePage = AppDelegate.SCREEN_HEIGHT - (constantTopOffset + AppDelegate.safeAreaTopInset() / 2.3)
            homePageHeightConstraint.constant = heightOfHomePage
            
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func openHomePageController() {
        guard let mapVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        
        mapVC.view.clipsToBounds = true
        mapVC.view.backgroundColor = .white
        addChildViewController(mapVC)
        view.addSubview(mapVC.view)
        mapVC.didMove(toParentViewController: self)
        
        self.mapVC = mapVC
        
        //mapVC.view.frame = CGRect(x: 0, y: 600, width: AppDelegate.SCREEN_WIDTH, height: AppDelegate.SCREEN_HEIGHT)
        mapVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        homePageBottomConstraint = NSLayoutConstraint(item: mapVC.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -bottomOffset)
        homePageBottomConstraint.isActive = true
        
        NSLayoutConstraint(item: mapVC.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapVC.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        homePageHeightConstraint = mapVC.view.heightAnchor.constraint(equalToConstant: heightOfHomePage)
        homePageHeightConstraint.isActive = true
        
        
        
        
        ////
        
        
//        homePageBottomConstraint = NSLayoutConstraint(item: mapVC.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
//        homePageBottomConstraint.isActive = true
//        NSLayoutConstraint(item: mapVC.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: mapVC.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
//        homePageHeightConstraint = mapVC.view.heightAnchor.constraint(equalToConstant: view.frame.size.height)
//        homePageHeightConstraint.isActive = true
        
        //////
        
        
        // JUST KEEP CODE // ADVANCED ONE BUT NOT USEFUL IN THIS CASE
        
//        let viewSafeArea : UILayoutGuide
//
//        if #available(iOS 11.0, *) {
//            viewSafeArea = view.safeAreaLayoutGuide
//        } else {
//            // Fallback on earlier versions
//            viewSafeArea = view.readableContentGuide
//        }
//        [
//            mapVC.view.topAnchor.constraint(equalTo: viewSafeArea.topAnchor, constant: bottomOffset),
//            mapVC.view.leadingAnchor.constraint(equalTo: viewSafeArea.leadingAnchor, constant: 0),
//            mapVC.view.trailingAnchor.constraint(equalTo: viewSafeArea.trailingAnchor, constant: 0),
//            mapVC.view.heightAnchor.constraint(equalTo: viewSafeArea.heightAnchor, multiplier: 1)
//            ].forEach { ($0.isActive = true) }
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnHomePage(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.mapVC.view.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        self.mapVC.view.addGestureRecognizer(panGesture)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 0.5)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            if runningAnimators.count == 0 {
                return
            }
            
            // variable setup
            let translation = recognizer.translation(in: self.mapVC.view)
            var fraction = -translation.y / topOffset
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            if runningAnimators.count == 0 {
                return
            }
            // variable setup
            let yVelocity = recognizer.velocity(in: self.mapVC.view).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
    
    
    
    /// Animates the transition, if the animation is not already running.
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
              self.openState()
                
            case .closed:
              self.closeState()
            }
            self.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.openState()
                
            case .closed:
               self.closeState()
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
//        // an animator for the title that is transitioning into view
//        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
//            switch state {
//            case .open:
//                self.openTitleLabel.alpha = 1
//            case .closed:
//                self.closedTitleLabel.alpha = 1
//            }
//        })
//        inTitleAnimator.scrubsLinearly = false
//
//        // an animator for the title that is transitioning out of view
//        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
//            switch state {
//            case .open:
//                self.closedTitleLabel.alpha = 0
//            case .closed:
//                self.openTitleLabel.alpha = 0
//            }
//        })
//        outTitleAnimator.scrubsLinearly = false
        
        // start all animators
        transitionAnimator.startAnimation()
//        inTitleAnimator.startAnimation()
//        outTitleAnimator.startAnimation()
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
//        runningAnimators.append(inTitleAnimator)
//        runningAnimators.append(outTitleAnimator)
        
    }
    
    func openState() {
        
        self.mapVC.topDropdownButton.setImage(UIImage(named: "dropdown_top"), for: .normal)
        self.backgroundViewTopConstraint.constant = self.topOffsetOfBackgroundView
        self.homePageBottomConstraint.constant = -self.topOffset;
        self.backgroundView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
        self.backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.backgroundView.layer.cornerRadius = 10
        self.mapVC.view.layer.cornerRadius = 10
        self.mapVC.containerViewAvailableTime.alpha = 0.0
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.tabBar.frame = CGRect(x: 0, y: AppDelegate.SCREEN_HEIGHT, width: self.tabBar.frame.size.width, height: self.tabBar.frame.size.height)
    }
    
    func closeState() {
        
        self.mapVC.topDropdownButton.setImage(UIImage(named: "dropdown_plain"), for: .normal)
        self.backgroundViewTopConstraint.constant = 0
        self.homePageBottomConstraint.constant = -self.bottomOffset
        self.backgroundView.transform = .identity
        self.backgroundView.backgroundColor = UIColor.white
        self.backgroundView.layer.cornerRadius = 0
        self.mapVC.view.layer.cornerRadius = 0
        self.mapVC.containerViewAvailableTime.alpha = 1.0
        self.setNeedsStatusBarAppearanceUpdate()
        self.tabBar.frame = CGRect(x: 0, y: AppDelegate.SCREEN_HEIGHT-self.tabBar.frame.size.height, width: self.tabBar.frame.size.width, height: self.tabBar.frame.size.height)
    }
    
    @objc func tappedOnHomePage(_ gesture: UITapGestureRecognizer) {
        
        if homePageBottomConstraint.constant == -bottomOffset {
            UIView.animate(withDuration: 0.25, animations: {
              self.openState()
                
            }, completion: { (finished) in
                
                self.currentState = self.currentState.opposite
            })
        }
        else {
            UIView.animate(withDuration: 0.25, animations: {
              self.closeState()
                
            }, completion: { (finished) in
                
                self.currentState = self.currentState.opposite
            })
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: { (finished) in
            
        })
        
//        self.mapVC.view.constraints.forEach { (constraint) in
//
//            if constraint.firstAttribute == .top {
//
//                constraint.constant = 0
//
//
//            }
//        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if homePageBottomConstraint.constant == -bottomOffset {
            return .default
        }
        else {
            return .lightContent
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


extension DealsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width * 0.6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "DEAL CELL"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! DealTableViewCell
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.dealImageView.image = UIImage.init(named: "deals_bg1")
            cell.lblDealTitle.text = "50% OFF"
            cell.lblDealDesc.text = "On bag & shoe cleaning"
            
            cell.lblDealTitle.textColor = AppColors.RGBColor(r: 77, g: 77, b: 77, a: 1.0)
            cell.lblDealDesc.textColor = AppColors.RGBColor(r: 77, g: 77, b: 77, a: 1.0)
        }
        else if indexPath.row == 1 {
            cell.dealImageView.image = UIImage.init(named: "deals_bg2")
            cell.lblDealTitle.text = "30% OFF"
            cell.lblDealDesc.text = "First shoe order"
            
            cell.lblDealTitle.textColor = .white
            cell.lblDealDesc.textColor = .white
        }
        else if indexPath.row == 2 {
            cell.dealImageView.image = UIImage.init(named: "deals_bg3")
        }
        
        cell.lblDealTitle.font = UIFont.init(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE+3)
        cell.lblDealDesc.font = UIFont.init(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-5)
        
        
        let attrKeyPO = [NSAttributedStringKey.foregroundColor : AppColors.blueColor, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE-8)!, NSAttributedStringKey.kern: NSNumber(value: 0.4)]
        let attrPO = NSAttributedString(string: "PLACE ORDER".uppercased(), attributes: attrKeyPO)
        
        cell.buttonPlaceOrder.setAttributedTitle(attrPO, for: .normal)
        cell.buttonPlaceOrder.layer.cornerRadius = cell.buttonPlaceOrder.frame.size.width * 0.15
        
        
//        cell.dealView.clipsToBounds = true
//        cell.dealView.layer.cornerRadius = 30
//
//        let shadowSize : CGFloat = 4.0
//        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
//                                                   y: -shadowSize / 2,
//                                                   width: cell.dealView.frame.size.width + shadowSize,
//                                                   height: cell.dealView.frame.size.height + shadowSize))
//
////        let shadowPath = UIBezierPath(roundedRect: CGRect(x: -shadowSize / 2,
////                                                          y: -shadowSize / 2,
////                                                          width: cell.dealView.frame.size.width + shadowSize,
////                                                          height: cell.dealView.frame.size.height + shadowSize), byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 5, height: 5))
//        cell.dealView.layer.shadowColor = UIColor.gray.cgColor
//        cell.dealView.layer.shadowOffset = CGSize(width: 2.0, height: 0.0)
//        cell.dealView.layer.shadowOpacity = 0.5
//        cell.dealView.layer.shadowRadius = 3.0
//        cell.dealView.layer.shadowPath = shadowPath.cgPath
//        cell.dealView.layer.masksToBounds = false
        
//        cell.dealView.clipsToBounds = true
//        cell.dealView.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize(width: -2, height: -5), radius: 5.0, scale: true)
//        cell.dealView.layer.cornerRadius = 12
        
        
        
//        cell.dealView.layer.shadowPath = UIBezierPath(roundedRect: cell.dealView.bounds, cornerRadius: 20).cgPath
//        cell.dealView.layer.shadowColor = UIColor.gray.cgColor
//        cell.dealView.layer.shadowOpacity = 0.5
//        cell.dealView.layer.shadowOffset = CGSize(width: -10, height: -20)
//        cell.dealView.layer.shadowRadius = 1
//        cell.dealView.layer.masksToBounds = false
//        cell.dealView.layer.cornerRadius = 20
        
        
        
        cell.dealView.clipsToBounds = true
        cell.dealView.layer.cornerRadius = 20
        cell.dealView.backgroundColor = .white
        
        cell.dealView.layer.shadowColor = UIColor.gray.cgColor
        cell.dealView.layer.shadowOffset = CGSize(width: -1.0, height: -1.0)
        cell.dealView.layer.shadowOpacity = 0.7
        cell.dealView.layer.shadowRadius = 5
        cell.dealView.layer.masksToBounds = false
        
        let shadowPath = UIBezierPath(roundedRect: cell.dealView.bounds, cornerRadius: 20)
        cell.dealView.layer.shadowPath = shadowPath.cgPath
        
        return cell
    }
}

//
//extension CALayer {
//    func addShadow() {
//        self.shadowOffset = .zero
//        self.shadowOpacity = 0.2
//        self.shadowRadius = 10
//        self.shadowColor = UIColor.black.cgColor
//        self.masksToBounds = false
//        if cornerRadius != 0 {
//            addShadowWithRoundedCorners()
//        }
//    }
//    func roundCorners(radius: CGFloat) {
//        self.cornerRadius = radius
//        if shadowOpacity != 0 {
//            addShadowWithRoundedCorners()
//        }
//    }
//
//    private func addShadowWithRoundedCorners() {
//        if let contents = self.contents {
//            masksToBounds = false
//            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
//                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
//            self.contents = nil
//            if let sublayer = sublayers?.first,
//                sublayer.name == "shadow" {
//
//                sublayer.removeFromSuperlayer()
//            }
//
//            let contentLayer = CALayer()
//            contentLayer.name = "shadow"
//            contentLayer.contents = contents
//            contentLayer.frame = bounds
//            contentLayer.cornerRadius = cornerRadius
//            contentLayer.masksToBounds = true
//            insertSublayer(contentLayer, at: 0)
//        }
//    }
//}
//
//extension UIView {
//
//    // OUTPUT 1
//    func dropShadow(scale: Bool = true) {
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowOffset = CGSize(width: -1, height: 1)
//        self.layer.shadowRadius = 1
//
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
//
//    // OUTPUT 2
//    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = color.cgColor
//        self.layer.shadowOpacity = opacity
//        self.layer.shadowOffset = offSet
//        self.layer.shadowRadius = radius
//
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
//}

