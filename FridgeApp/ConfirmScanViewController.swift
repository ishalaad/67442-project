//
//  ConfirmScanViewController.swift
//  FridgeApp
//
//  Created by Sydney Bauer on 11/8/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import UIKit
import CoreData

class ConfirmScanViewController: UIViewController {
  
  var name:String?
  var expDate:String?
  
  @IBOutlet weak var nameEditField: UITextField?
  @IBOutlet weak var expDateEditField: UITextField?
  @IBOutlet weak var quantityInputField: UITextField!
  @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      nameEditField?.text = name ?? "Name not found"
      expDateEditField?.text = expDate?.replacingOccurrences(of: " ", with: "") ?? "Date not found"
    }
  
  @IBAction func cancelScan() {
    if let nav = self.navigationController {
      nav.popViewController(animated: true)
    } else {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func submit() {
    
    let fridgeItem = FridgeItem()
    fridgeItem.name = (nameEditField?.text!)!
    fridgeItem.quantity = Int(quantityInputField.text!)
    fridgeItem.expDate = Int(expDateEditField!.text!)
    if fridgeItem.name.count > 0 {
      
      saveFridgeItem(fridgeItem: fridgeItem)
    }
    
  }
  
  func saveFridgeItem(fridgeItem: FridgeItem) {
    // Connect to the context for the container stack
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    // Specifically select the People entity to save this object to
    let entity = NSEntityDescription.entity(forEntityName: "FridgeListItem", in: context)
    let newItem = NSManagedObject(entity: entity!, insertInto: context)
    // Set values one at a time and save
    newItem.setValue(fridgeItem.name, forKey: "name")
    newItem.setValue(fridgeItem.quantity, forKey: "quantity")
    newItem.setValue(fridgeItem.expDate, forKey: "expDate")
    do {
      try context.save()
      
      print("SAVED")
    } catch {
      print("Failed saving")
    }
  }
}
