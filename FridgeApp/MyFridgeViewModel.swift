//
//  MyFridgeViewModel.swift
//  FridgeApp
//
//  Created by Sydney Bauer on 11/27/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import Foundation

class MyFridgeViewModel {
  
  func detailViewModelForRowAtIndexPath(_ indexPath: IndexPath, _ fridgeItems: [FridgeItem]) -> ItemDetailViewModel {
    return ItemDetailViewModel(item: fridgeItems[indexPath.row])
  }
}
