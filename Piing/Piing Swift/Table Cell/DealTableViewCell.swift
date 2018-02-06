//
//  DealTableViewCell.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 30/01/18.
//  Copyright © 2018 Piing. All rights reserved.
//

import UIKit

class DealTableViewCell: UITableViewCell {

    @IBOutlet weak var dealView: UIView!
    @IBOutlet weak var dealImageView: UIImageView!
    @IBOutlet weak var lblDealTitle: UILabel!
    @IBOutlet weak var lblDealDesc: UILabel!
    @IBOutlet weak var buttonPlaceOrder: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
