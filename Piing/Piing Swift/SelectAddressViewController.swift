//
//  SelectAddressViewController.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 15/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit


protocol SelectAddressViewControllerDelegate: NSObjectProtocol {
    func doneAfterAddressSelectionPressedWith(addressModel: AddressModel, addressType: AddressType)
}

enum AddressType: String {
    case PICKUP
    case DELIVERY
}

class SelectAddressViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: SelectAddressViewControllerDelegate?
    
    @IBOutlet private weak var addressView: UIView! {
        didSet {
            addressView.layer.masksToBounds = false
            addressView.layer.shadowColor = UIColor.lightGray.cgColor
            addressView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            addressView.layer.shadowOpacity = 0.5
            addressView.layer.shadowRadius = 1.0
        }
    }
    
    @IBOutlet private weak var tableViewAddress: UITableView!
    
    @IBOutlet private weak var addressHeaderButton: UIButton!
    @IBOutlet private weak var addressName: UILabel!
    @IBOutlet private weak var addressDescription: UILabel!
    
    @IBOutlet private weak var doneButton: UIButton! {
        didSet {
            // Set Done Button
            let attrKeyDone = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BLACK, size: AppDelegate.GLOBAL_FONT_SIZE)!, NSAttributedStringKey.kern: NSNumber(value: 2.0)]
            let attrDone = NSAttributedString(string: "DONE", attributes: attrKeyDone)
            
            doneButton.setAttributedTitle(attrDone, for: .normal)
        }
    }
    
    var addressArray = [AddressModel]()
    
    var addressModel: AddressModel?
    
    var addressType = AddressType(rawValue: "PICKUP")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Header
        let attrKeyHeader = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_HEAVY, size: AppDelegate.GLOBAL_FONT_SIZE-3)!, NSAttributedStringKey.kern: NSNumber(value: 2.0)]
        
        var attrHeader: NSAttributedString?
        
        switch addressType {
        case .PICKUP?:
            attrHeader = NSAttributedString(string: AddressType.PICKUP.rawValue, attributes: attrKeyHeader)
        case .DELIVERY?:
            attrHeader = NSAttributedString(string: AddressType.DELIVERY.rawValue, attributes: attrKeyHeader)
        default:
            break
        }
        
        addressHeaderButton.setAttributedTitle(attrHeader, for: .normal)
        addressHeaderButton.imageEdgeInsets = UIEdgeInsetsMake(addressHeaderButton.frame.size.height * 0.3, -5, addressHeaderButton.frame.size.height * 0.3, 0)
        addressHeaderButton.imageView?.contentMode = .scaleAspectFit
        
        setupAddress()
        
        tableViewAddress.estimatedRowHeight = 100
        tableViewAddress.rowHeight = UITableViewAutomaticDimension
        tableViewAddress.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the status bar
        statusBarShouldBeHidden = false
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private func setupAddress() {
        
        guard let addressModel = addressModel else { return }
        
        // Set Address Name
        let attrKeyAddressName = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
        let attrAddressName = NSAttributedString(string: addressModel.name!, attributes: attrKeyAddressName)
        addressName.attributedText = attrAddressName
        
        let strLaneAddr = AppDelegate.getAddressDescription(addressModel)
        
        // Set Address Description
        let attrKeyAddressDesc = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_REGULAR, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
        let attrAddressDesc = NSAttributedString(string: strLaneAddr, attributes: attrKeyAddressDesc)
        addressDescription.attributedText = attrAddressDesc
        addressDescription.numberOfLines = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addressArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if addressArray.count > indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ADDRESS_CELL") as! AddressTableViewCell
            cell.selectionStyle = .none
            
            let addressModel = addressArray[indexPath.row]
            
            // Set Address Name
            let attrKeyAddressName = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
            let attrAddressName = NSAttributedString(string: addressModel.name!, attributes: attrKeyAddressName)
            cell.lblAddressName.attributedText = attrAddressName
            
            let strLaneAddr = AppDelegate.getAddressDescription(addressModel)
            
            // Set Address Description
            let attrKeyAddressDesc = [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_REGULAR, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.6)]
            let attrAddressDesc = NSAttributedString(string: strLaneAddr, attributes: attrKeyAddressDesc)
            cell.lblAddressDescription.attributedText = attrAddressDesc
            cell.lblAddressDescription.numberOfLines = 0
            
            if addressModel._id == self.addressModel?._id {
                cell.selectedRowImageView.isHidden = false
            }
            else {
                cell.selectedRowImageView.isHidden = true
            }
            
            return cell
        }
        else {
            
            let cellId = "ADD_ADDRESS_CELL"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
            cell!.selectionStyle = .none
            
            let lblAddAddress = cell?.contentView.viewWithTag(1) as! UILabel
            
            let attrKeyAddressName = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name: AppFont.APPFONT_BOLD, size: AppDelegate.GLOBAL_FONT_SIZE-5)!, NSAttributedStringKey.kern: NSNumber(value: 0.7)]
            let attrAddressName = NSAttributedString(string: "+ ADD ADDRESS", attributes: attrKeyAddressName)
            lblAddAddress.attributedText = attrAddressName
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if addressArray.count > indexPath.row {
            let addressModel = addressArray[indexPath.row]
            self.addressModel = addressModel
            
            setupAddress()
            
            tableView.reloadData()
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.layoutIfNeeded()
                
            }) { (success) in
                
            }
        }
        else {
            
            guard let addAddressVC = AppDelegate.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController else { return }
            
            // Hide the status bar
            statusBarShouldBeHidden = true
            UIView.animate(withDuration: 0.25) {
                self.setNeedsStatusBarAppearanceUpdate()
                self.view.layoutIfNeeded()
            }
            
            present(addAddressVC, animated: true, completion: nil)
            
        }
    }
    
    private var statusBarShouldBeHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    @IBAction private func doneButtonPressed(_ sender: UIButton) {
        
        self.delegate?.doneAfterAddressSelectionPressedWith(addressModel: self.addressModel!, addressType: self.addressType!)
        
        dismiss(animated: true) {
            
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
