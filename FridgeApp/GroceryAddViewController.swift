//
//  GroceryAddViewController.swift
//  FridgeApp
//
//  Created by Sydney Bauer on 10/31/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import UIKit
import CoreData
import Foundation

protocol GroceryAddViewControllerDelegate: class {
  func GroceryAddViewControllerDidCancel(controller: GroceryAddViewController)
  
  func GroceryAddViewController(controller: GroceryAddViewController, didFinishAddingGrocItem grocItem: GrocItem)
}

class GroceryAddViewController: UIViewController, UINavigationControllerDelegate {
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var quantityField: UITextField!
  @IBOutlet weak var submitButton: UIButton!
  
  weak var delegate: GroceryAddViewControllerDelegate?
  

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    nameField.becomeFirstResponder()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func cancel() {
    delegate?.GroceryAddViewControllerDidCancel(controller: self)
  }
  
  @IBAction func submit() {
    let grocItem = GrocItem()
    grocItem.name = nameField.text!
    grocItem.quantity = Int(quantityField.text!)
    if grocItem.name.count > 0 {
      saveGroceryItem(grocItem: grocItem)
      delegate?.GroceryAddViewController(controller: self, didFinishAddingGrocItem: grocItem)
    }
  }
    
  func saveGroceryItem(grocItem: GrocItem) {
    // Connect to the context for the container stack
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    // Specifically select the People entity to save this object to
    let entity = NSEntityDescription.entity(forEntityName: "GroceryListItem", in: context)
    let newItem = NSManagedObject(entity: entity!, insertInto: context)
    // Set values one at a time and save
    newItem.setValue(grocItem.name, forKey: "name")
    newItem.setValue(grocItem.quantity, forKey: "quantity")
    // Safely unwrap the picture
    do {
      try context.save()
      print("SAVED")
    } catch {
      print("Failed saving")
    }
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
