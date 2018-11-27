//
//  ItemDetailViewModel.swift
//  FridgeApp
//
//  Created by Sydney Bauer on 11/27/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import Foundation

class ItemDetailViewModel {
  
  var fridgeItem: FridgeItem
  
  init(item: FridgeItem){
    self.fridgeItem = item
  }
  
  func name() -> String {
    return fridgeItem.name
  }
  
  func expDate() -> String {
    return String(fridgeItem.expDate!)
  }
  
  func quantity() -> String {
    return String(fridgeItem.quantity!)
  }
  
}
