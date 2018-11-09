//
//  ManuallyAddViewController.swift
//  FridgeApp
//
//  Created by Isha Laad on 11/4/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import UIKit

import CoreData
import Foundation

protocol ManuallyAddViewControllerDelegate: class {
	func ManuallyAddViewControllerDidCancel(controller: ManuallyAddViewController)
	
	func ManuallyAddViewController(controller: ManuallyAddViewController, didFinishAddingFridgeItem fridgeItem: FridgeItem)
}

class ManuallyAddViewController: UIViewController, UINavigationControllerDelegate {
	
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var quantityField: UITextField!
	@IBOutlet weak var expDateField: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	
	weak var delegate: ManuallyAddViewControllerDelegate?
	
	
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
    print ("cancel")
    //    delegate?.ManuallyAddViewControllerDidCancel(controller: self)
    if let nav = self.navigationController {
      nav.popViewController(animated: true)
    } else {
      self.dismiss(animated: true, completion: nil)
    }
    
  }
	
	@IBAction func submit() {
		let fridgeItem = FridgeItem()
		fridgeItem.name = nameField.text!
		fridgeItem.quantity = Int(quantityField.text!)
		fridgeItem.expDate = Int(expDateField.text!)
		if fridgeItem.name.count > 0 {
			saveFridgeItem(fridgeItem: fridgeItem)
			//_ = navigationController?.popViewController(animated: true)
			delegate?.ManuallyAddViewController(controller: self, didFinishAddingFridgeItem: fridgeItem)
		}
		//navigationController?.popViewController(animated: true)
		//_ = navigationController?.popViewController(animated: true)
//		let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyFridgeViewController") as? MyFridgeViewController
//		self.navigationController?.pushViewController(vc!, animated: true)
		
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
		// Safely unwrap the picture
		do {
			try context.save()
			print("SAVED")
		} catch {
			print("Failed saving")
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "myFridge" {
			let navigationController = segue.destination as! UINavigationController
			let controller = navigationController.topViewController as! MyFridgeViewController
			//controller.delegate = self
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
