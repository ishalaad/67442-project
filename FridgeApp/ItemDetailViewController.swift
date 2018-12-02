//
//  ItemDetailViewController.swift
//  FridgeApp
//
//  Created by Sydney Bauer on 11/27/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
  
  var viewModel: ItemDetailViewModel?
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var expDateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      nameLabel.text = viewModel!.name()
      expDateLabel.text = viewModel!.expDate()
    }

  

}
