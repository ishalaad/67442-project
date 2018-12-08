//
//  GroceryListViewController.swift
//  FridgeApp
//
//  Created by Sydney Bauer on 10/31/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import UIKit
import CoreData

class GroceryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GroceryAddViewControllerDelegate  {
  
  var grocItems = [GrocItem]()
	var dataManager = DataManager()
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var grocListTop: UIImageView!

    override func viewDidLoad() {
      tableView.dataSource = self
      tableView.delegate = self

        // Do any additional setup after loading the view.
      let cellNib = UINib(nibName: "GroceryTableViewCell", bundle: nil)
      self.tableView.register(cellNib.self, forCellReuseIdentifier: "grocCell")
      
      // Again set up the stack to interface with CoreData
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GroceryListItem")
      request.returnsObjectsAsFaults = false
      do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
          self.loadGroceryList(data: data)
          print(data.value(forKey: "name") as! String)
        }
      } catch {
        print("Failed")
      }
			
    }
  
  func loadGroceryList(data: NSManagedObject){
    let newGroceryItem = GrocItem()
    newGroceryItem.name = data.value(forKey: "name") as! String
    newGroceryItem.quantity = (data.value(forKey: "quantity") as! Int)
    grocItems.append(newGroceryItem)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return grocItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "grocCell", for: indexPath as IndexPath) as! GroceryTableViewCell
    
    let grocItem = grocItems[indexPath.row]
    cell.name?.text = grocItem.name
    cell.quantity?.text = "\(grocItem.quantity!)"
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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GroceryListItem")
    
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
      request.returnsObjectsAsFaults = false
      do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
          // if the contact we are deleting is the same as this one in CoreData
          if self.grocItems[indexPath.row].name == (data.value(forKey: "name") as! String) &&
            self.grocItems[indexPath.row].quantity == (data.value(forKey: "quantity") as! Int){
            print("----------------DELETED \(self.grocItems[indexPath.row].name) FROM CONTEXT----------------")
            context.delete(data)
            try context.save()
          }
        }
      } catch {
        print("Failed")
      }
      self.grocItems.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
    }
    
    let purchase = UITableViewRowAction(style: .normal, title: "Purchase") { (action, indexPath) in
      // share item at indexPath
      print("PURCHASED \(self.grocItems[indexPath.row].name)")
      
      request.returnsObjectsAsFaults = false
      do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
          // if the grocItem we are deleting is the same as this one in CoreData
          if self.grocItems[indexPath.row].name == (data.value(forKey: "name") as! String) &&
            self.grocItems[indexPath.row].quantity == (data.value(forKey: "quantity") as! Int){
            print("----------------PURCHASED \(self.grocItems[indexPath.row].name)----------------")
            context.delete(data)
            try context.save()
          }
        }
      } catch {
        print("Failed")
      }
      self.grocItems.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
    }
    
    purchase.backgroundColor = UIColor.blue
    
    return [delete, purchase]
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "addGrocItem" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! GroceryAddViewController
      controller.delegate = self
    }
  }
  
  func GroceryAddViewControllerDidCancel(controller: GroceryAddViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func GroceryAddViewController(controller: GroceryAddViewController, didFinishAddingGrocItem grocItem: GrocItem) {
    let newRowIndex = grocItems.count
    
    grocItems.append(grocItem)
    
    let indexPath = NSIndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
    
    dismiss(animated: true, completion: nil)
  }

}
