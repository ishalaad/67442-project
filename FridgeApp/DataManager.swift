//
//  GrocDataManager.swift
//  FridgeApp
//
//  Created by Sydney Bauer on 10/31/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import Foundation

// MARK: - String Extension

extension String {
  // recreating a function that String class no longer supports in Swift 2.3
  // but still exists in the NSString class. (This trick is useful in other
  // contexts as well when moving between NS classes and Swift counterparts.)
  
  /**
   Returns a new string made by appending to the receiver a given string.  In this case, a new string
   made by appending 'aPath' to the receiver, preceded if necessary by a path separator.
   
   - parameter aPath: The path component to append to the receiver. (String)
   - returns: A new string made by appending 'aPath' to the receiver, preceded if necessary by a path separator. (String)
   
   */
  func stringByAppendingPathComponent(aPath: String) -> String {
    let nsSt = self as NSString
    return nsSt.appendingPathComponent(aPath)
  }
}


// MARK: - Data Manager Class
class DataManager {
  
  // MARK: - General
  var grocItems = [GrocItem]()
	var fridgeItems = [FridgeItem]()
  
  init() {
    loadGrocItems()
    // print("Documents folder is \(documentsDirectory())\n")
    // print("Data file path is \(dataFilePath())")
  }
  
  
  // MARK: - Data Location Methods
  
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    return paths[0]
  }
  
  func dataFilePath() -> String {
    return documentsDirectory().stringByAppendingPathComponent(aPath: "Contacts.plist")
  }
  
  
  // MARK: - Saving & Loading Data
  
  /**
   Saves contact data to a plist.
   */
  func saveGrocItems() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    archiver.encode(grocItems, forKey: "GrocItems")
    archiver.finishEncoding()
    data.write(toFile: dataFilePath(), atomically: true)
  }
  
  /**
   Loads the data from a plist into contacts array.
   */
  func loadGrocItems() {
    let path = dataFilePath()
    if FileManager.default.fileExists(atPath: path) {
      if let data = NSData(contentsOfFile: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
        self.grocItems = unarchiver.decodeObject(forKey: "GrocItems") as! [GrocItem]
        unarchiver.finishDecoding()
      } else {
        print("\nFILE NOT FOUND AT: \(path)")
      }
    }
  }
	
	func saveFridgeItems() {
		let data = NSMutableData()
		let archiver = NSKeyedArchiver(forWritingWith: data)
		archiver.encode(fridgeItems, forKey: "FridgeItems")
		archiver.finishEncoding()
		data.write(toFile: dataFilePath(), atomically: true)
	}
	
	/**
	Loads the data from a plist into contacts array.
	*/
	func loadFridgeItems() {
		let path = dataFilePath()
		if FileManager.default.fileExists(atPath: path) {
			if let data = NSData(contentsOfFile: path) {
				let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
				self.fridgeItems = unarchiver.decodeObject(forKey: "FridgeItems") as! [FridgeItem]
				unarchiver.finishDecoding()
			} else {
				print("\nFILE NOT FOUND AT: \(path)")
			}
		}
	}
}
