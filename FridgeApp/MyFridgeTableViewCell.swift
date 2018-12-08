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
    @IBOutlet weak var expDate: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var foodIcon: UIImageView!
    @IBOutlet weak var daysLeft: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
