//
//  MyFridgeTableViewCell.swift
//  FridgeApp
//
//  Created by Isha Laad on 11/4/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import UIKit

class MyFridgeTableViewCell: UITableViewCell {
	
	@IBOutlet weak var name: UILabel!
//	@IBOutlet weak var q: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
