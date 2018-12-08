//
//  FridgeAppTests.swift
//  FridgeAppTests
//
//  Created by Sydney Bauer on 10/31/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import XCTest
@testable import FridgeApp

class FridgeAppTests: XCTestCase {
  
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateFridgeItem() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      var createFridgeItems = [FridgeItem]()
      let newFridgeItem = FridgeItem()
      newFridgeItem.name = "Apple"
      newFridgeItem.quantity = 2
      newFridgeItem.expDate = 2
      createFridgeItems.append(newFridgeItem)
      XCTAssertEqual(createFridgeItems.count, 1)
      XCTAssertEqual(createFridgeItems[0].name, "Apple")
      XCTAssertEqual(createFridgeItems[0].quantity, 2)
      XCTAssertEqual(createFridgeItems[0].expDate, 2)
      let newFridgeItem2 = FridgeItem()
      newFridgeItem2.name = "Kiwi"
      newFridgeItem2.quantity = 5
      newFridgeItem2.expDate = 12
      createFridgeItems.append(newFridgeItem2)
      XCTAssertEqual(createFridgeItems.count, 2)
      XCTAssertEqual(createFridgeItems[1].name, "Kiwi")
      XCTAssertEqual(createFridgeItems[1].quantity, 5)
      XCTAssertEqual(createFridgeItems[1].expDate, 12)
    }
  
  func testDeleteFridgeItem() {
    var deleteFridgeItems = [FridgeItem]()
    let newFridgeItem = FridgeItem()
    newFridgeItem.name = "Apple"
    newFridgeItem.quantity = 2
    newFridgeItem.expDate = 2
    deleteFridgeItems.append(newFridgeItem)
    let newFridgeItem2 = FridgeItem()
    newFridgeItem2.name = "Kiwi"
    newFridgeItem2.quantity = 5
    newFridgeItem2.expDate = 12
    deleteFridgeItems.append(newFridgeItem2)
    XCTAssertEqual(deleteFridgeItems.count, 2)
    deleteFridgeItems.remove(at: 0)
    XCTAssertEqual(deleteFridgeItems.count, 1)
    XCTAssertEqual(deleteFridgeItems[0].name, "Kiwi")
    XCTAssertEqual(deleteFridgeItems[0].quantity, 5)
    XCTAssertEqual(deleteFridgeItems[0].expDate, 12)
  }
  
  func testCreateGroceryItem() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    var createGroceryItems = [GrocItem]()
    let newGroceryItem = GrocItem()
    newGroceryItem.name = "Apple"
    newGroceryItem.quantity = 2
    createGroceryItems.append(newGroceryItem)
    XCTAssertEqual(createGroceryItems.count, 1)
    XCTAssertEqual(createGroceryItems[0].name, "Apple")
    XCTAssertEqual(createGroceryItems[0].quantity, 2)
    let newGroceryItem2 = GrocItem()
    newGroceryItem2.name = "Kiwi"
    newGroceryItem2.quantity = 5
    createGroceryItems.append(newGroceryItem2)
    XCTAssertEqual(createGroceryItems.count, 2)
    XCTAssertEqual(createGroceryItems[1].name, "Kiwi")
    XCTAssertEqual(createGroceryItems[1].quantity, 5)
  }
  
  func testDeleteGroceryItem() {
    var deleteGroceryItems = [GrocItem]()
    let newGrocItem = GrocItem()
    newGrocItem.name = "Apple"
    newGrocItem.quantity = 2
    deleteGroceryItems.append(newGrocItem)
    let newGrocItem2 = GrocItem()
    newGrocItem2.name = "Kiwi"
    newGrocItem2.quantity = 5
    deleteGroceryItems.append(newGrocItem2)
    XCTAssertEqual(deleteGroceryItems.count, 2)
    deleteGroceryItems.remove(at: 0)
    XCTAssertEqual(deleteGroceryItems.count, 1)
    XCTAssertEqual(deleteGroceryItems[0].name, "Kiwi")
    XCTAssertEqual(deleteGroceryItems[0].quantity, 5)
  }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
