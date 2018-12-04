//
//  SecondViewController.swift
//  FridgeApp
//
//  Created by Sydney Bauer on 10/31/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import UIKit
import CoreData


class MyFridgeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, ManuallyAddViewControllerDelegate {
    
	var fridgeItems = [FridgeItem]()
	var dataManager = DataManager()
	@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fridgeTop: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
//          let appDelegate1 = UIApplication.shared.delegate as! AppDelegate
//          let context1 = appDelegate1.persistentContainer.viewContext
//          let request1 = NSFetchRequest<NSFetchRequestResult>(entityName: "FridgeListItem")
//          request1.returnsObjectsAsFaults = false
//          do {
//            let result = try context1.fetch(request1)
//            for data in result as! [NSManagedObject] {
//              context1.delete(data)
//              try context1.save()
//            }
//          } catch {
//            print("Failed")
//          }
//          fridgeItems.remove(at: indexPath.row)
//          tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
		tableView.dataSource = self
		tableView.delegate = self
        fridgeTop.image = UIImage(named: "fridgeTop3")
		// Do any additional setup after loading the view.
		let cellNib = UINib(nibName: "MyFridgeTableViewCell", bundle: nil)
		self.tableView.register(cellNib.self, forCellReuseIdentifier: "fridgeCell")
		
		// Again set up the stack to interface with CoreData
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FridgeListItem")
		request.returnsObjectsAsFaults = false
		do {
			let result = try context.fetch(request)
			for data in result as! [NSManagedObject] {
				self.loadMyFridgeList(data: data)
				print(data.value(forKey: "name") as! String)
			}
		} catch {
			print("Failed")
		}
      let imageView = UIImageView(image: UIImage(named: "shelves3"))
      var frame = imageView.frame
      frame.size.height = tableView.frame.height
      frame.size.width = tableView.frame.width
      /* other frame changes ... */
      imageView.frame = frame
      tableView.backgroundView = UIView()
      tableView.backgroundView!.addSubview(imageView)
	}
  
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      if let selectedRow = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: selectedRow, animated: true)
      }
    }
	
	func ManuallyAddViewControllerDidCancel(controller: ManuallyAddViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	func ManuallyAddViewController(controller: ManuallyAddViewController, didFinishAddingFridgeItem fridgeItem: FridgeItem) {
		let newRowIndex = fridgeItems.count
		
		fridgeItems.append(fridgeItem)
		
		let indexPath = NSIndexPath(row: newRowIndex, section: 0)
		let indexPaths = [indexPath]
		tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
		
		dismiss(animated: true, completion: nil)
	}
	
	
	func loadMyFridgeList(data: NSManagedObject){
		let newFridgeItem = FridgeItem()
		newFridgeItem.name = data.value(forKey: "name") as! String
		newFridgeItem.quantity = (data.value(forKey: "quantity") as! Int)
		newFridgeItem.expDate = (data.value(forKey: "expDate") as! Int)
		fridgeItems.append(newFridgeItem)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fridgeItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "fridgeCell", for: indexPath as IndexPath) as! MyFridgeTableViewCell
		let fridgeItem = fridgeItems[indexPath.row]
        if (fridgeItem.expDate! < 4) {
          cell.name?.textColor = UIColor.red
          cell.expDate?.textColor = UIColor.red
          cell.quantity?.textColor = UIColor.red
          cell.daysLeft?.textColor = UIColor.red
        } else {
          cell.name?.textColor = UIColor.black
          cell.expDate?.textColor = UIColor.black
          cell.quantity?.textColor = UIColor.black
          cell.daysLeft?.textColor = UIColor.black
        }
		cell.name?.text = fridgeItem.name
        cell.expDate?.text = String(fridgeItem.expDate!)
        cell.quantity?.text = String(fridgeItem.quantity!)
        let foodIconArray = ["Apples", "Bananas", "Milk", "Oranges", "Grapes","Lettuce","Strawberries","Yogurt", "Eggs", "Kiwi", "Kiwifruit","Watermelon"]
        if foodIconArray.contains(fridgeItem.name){
          cell.foodIcon.image = UIImage(named: "\(fridgeItem.name)Icon")
        } else {
          cell.foodIcon.image = UIImage(named: "notFoundIcon")
        }
        cell.backgroundColor = UIColor.clear
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let context = appDelegate.persistentContainer.viewContext
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FridgeListItem")
			request.returnsObjectsAsFaults = false
			do {
				let result = try context.fetch(request)
				for data in result as! [NSManagedObject] {
					// if the contact we are deleting is the same as this one in CoreData
					if self.fridgeItems[indexPath.row].name == (data.value(forKey: "name") as! String) &&
						self.fridgeItems[indexPath.row].quantity == (data.value(forKey: "quantity") as! Int) &&
						self.fridgeItems[indexPath.row].expDate == (data.value(forKey: "expDate") as! Int) {
						print("----------------DELETED \(self.fridgeItems[indexPath.row].name) FROM CONTEXT----------------")
						context.delete(data)
						try context.save()
					}
				}
			} catch {
				print("Failed")
			}
			self.fridgeItems.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
		}
		
		return [delete]
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let selectedRow = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: selectedRow, animated: true)
      }
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "manAddFridgeItem" {
			let navigationController = segue.destination as! UINavigationController
			let controller = navigationController.topViewController as! ManuallyAddViewController
			controller.delegate = self
		}

	}
	
}

