//
//  MyFridgeViewModel.swift
//  FridgeApp
//
//  Created by Sydney Bauer on 11/27/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import Foundation

class MyFridgeViewModel {
//  var fridgeItems = [FridgeItem]()

  
//  func numberOfRows() -> Int {
//    // Your code here
//    return fridgeItems.count
//  }
//
//  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
//    guard indexPath.row >= 0 && indexPath.row < fridgeItems.count else {
//      return ""
//    }
//    // Your code here
//    return fridgeItems[indexPath.row].name
//
//  }
  
  func detailViewModelForRowAtIndexPath(_ indexPath: IndexPath, _ fridgeItems: [FridgeItem]) -> ItemDetailViewModel {
    return ItemDetailViewModel(item: fridgeItems[indexPath.row])
  }
}
