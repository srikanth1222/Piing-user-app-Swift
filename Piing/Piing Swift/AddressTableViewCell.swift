//
//  AddressTableViewCell.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 15/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAddressName: UILabel!
    @IBOutlet weak var lblAddressDescription: UILabel!
    @IBOutlet weak var selectedRowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
