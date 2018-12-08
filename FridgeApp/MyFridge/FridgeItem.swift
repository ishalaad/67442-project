//
//  FridgeItem.swift
//  FridgeApp
//
//  Created by Isha Laad on 11/4/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import Foundation
import UIKit

class FridgeItem: NSObject, NSCoding {
	
	var name: String = "Fruit"
	var quantity: Int?
	var expDate: Int?
	
	
	override init(){
		super.init()
	}
	
	// MARK: - Encoding
	required init(coder aDecoder: NSCoder) {
		self.name = aDecoder.decodeObject(forKey: "Name") as! String
		self.quantity = aDecoder.decodeObject(forKey: "Quantity") as? Int
		self.expDate = aDecoder.decodeObject(forKey: "ExpDate") as? Int
		super.init()
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: "Name")
		aCoder.encode(quantity, forKey: "Quantity")
		aCoder.encode(expDate, forKey: "ExpDate")
	}
	
}

