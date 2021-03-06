//
//  FirstViewController.swift
//  FridgeApp
//
//  Created by Sydney Bauer on 10/31/18.
//  Copyright © 2018 Sydney Bauer. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
	
	let commonItemsStrings:[String] = ["Apples", "Milk", "Bananas", "Yogurt", "Strawberries", "Grapes", "Lettuce", "Oranges", "Eggs"]
	var selectedItems:[String] = []
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return commonItemsStrings.count
	}

	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
		
		cell.myLabel.text = commonItemsStrings[indexPath.item]
		let itemImage = UIImage(named: commonItemsStrings[indexPath.item] + ".jpg")
		//let itemImage    = UIImage(contentsOfFile: commonItemsStrings[indexPath.item] + ".jpg")
		cell.pic.image = itemImage
		
		collectionView.allowsMultipleSelection = true
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print(commonItemsStrings[indexPath.item])

		let cell = collectionView.cellForItem(at: indexPath)
		if cell?.isSelected == true {
			cell?.layer.borderColor = UIColor.black.cgColor
			cell?.layer.borderWidth = 3
		}
        //add selected items
		selectedItems.append(commonItemsStrings[indexPath.item])
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)!
		if cell.isSelected == false {
			cell.layer.borderColor = UIColor.white.cgColor
		}
		
        //remove unselected comments from selected items list
		selectedItems.index(of: commonItemsStrings[indexPath.item]).map { selectedItems.remove(at: $0) }
		
	}
	
	
	@IBAction func loadAddedCommonItemsList() {
		print (selectedItems)
        // dictionary of 9 quick add items
		var dictExpirationDates = ["Apples": [12, 22], "Milk": [1, 6], "Bananas": [6, 7], "Yogurt": [4, 4], "Strawberries": [20, 6], "Grapes": [1, 5], "Lettuce": [1, 4], "Oranges": [10, 9], "Eggs": [12, 10]]
		for item in selectedItems {
			let fridgeItem = FridgeItem()
			fridgeItem.name = item
			fridgeItem.quantity = dictExpirationDates[item]?[0]
			fridgeItem.expDate = dictExpirationDates[item]?[1]
			if fridgeItem.name.count > 0 {
				saveFridgeItem(fridgeItem: fridgeItem)
			}
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
	//scan in
  
  let imagePicker = UIImagePickerController()
  let session = URLSession.shared
  var itemArray = [String.SubSequence]()
  var fridgeItems = [FridgeItem]()
  
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var labelResults: UITextView!
  
  weak var delegate: ManuallyAddViewControllerDelegate?
  
  //Google Cloud Vision API information
  var googleAPIKey = "AIzaSyAWNssKrhgP9TgMwRUPvnK3g-vL8dKZBpU"
  var googleURL: URL {
    return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
  }
  
  @IBAction func loadImageButtonTapped(_ sender: UIButton) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .photoLibrary
    
    present(imagePicker, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
    labelResults.isHidden = true
    spinner.hidesWhenStopped = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.destination is ConfirmScanViewController {
      let vc = segue.destination as? ConfirmScanViewController
      vc?.name = String(self.itemArray[0])
      vc?.expDate = String(self.itemArray[1])
      labelResults.text = ""
    }
  }
}


/// Image processing

extension ScanViewController {
  
  func analyzeResults(_ dataToParse: Data) {
    
    // Update UI on the main thread
    DispatchQueue.main.async(execute: {
      
      
      // Use SwiftyJSON to parse results
      let json = JSON(data: dataToParse)
      let errorObj: JSON = json["error"]
      
      self.spinner.stopAnimating()
      self.labelResults.isHidden = false
      
      // Check for errors
      if (errorObj.dictionaryValue != [:]) {
        self.labelResults.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
      } else {
        // Parse the response
        let responses: JSON = json["responses"][0]
        
        // Get label annotations
        let labelAnnotations: JSON = responses["labelAnnotations"]
        let numLabels: Int = labelAnnotations.count
        var labels: Array<String> = []
        if numLabels > 0 {
          var labelResultsText:String = ""
          for index in 0..<numLabels {
            let label = labelAnnotations[index]["description"].stringValue
            labels.append(label)
          }
          for label in labels {
            // if it's not the last item add a comma
            if labels[labels.count - 1] != label {
              labelResultsText += "\(label), "
            } else {
              labelResultsText += "\(label)"
            }
          }
          self.identifyItem(APIresults: labelResultsText)
          
        } else {
          self.labelResults.text = "No labels found"
        }
      }
    })
    
  }
  
  func createAlert(){
    let alert = UIAlertController(title: "Food in picture not found!", message: "Try manually adding your item", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    self.present(alert, animated: true)
  }
  
  func identifyItem (APIresults: String) {
    //search words in txt file
    let userPath = Bundle.main.path(forResource: "foodExpiration", ofType: "txt")
    do {
      // Get the contents of the file
      let contents = try NSString(contentsOfFile: userPath!, encoding: String.Encoding.utf8.rawValue)
      //split up google vision label results
      let results = APIresults.split(separator: ",")
      var stopLoop = false
      contents.enumerateLines({ (line, stop) in
        for word in results{
          if line.contains(word.trimmingCharacters(in: .whitespaces).capitalized), stopLoop == false{
            self.itemArray = line.split(separator: ",")
            let finalResults = "\(self.itemArray[0]) will expire in \(self.itemArray[1])"
            print(finalResults)
            self.labelResults.text = finalResults
            stopLoop = true
            let vc = ConfirmScanViewController()
            vc.name = String(self.itemArray[0])
            vc.expDate = String(self.itemArray[1])
            self.performSegue(withIdentifier: "confirmScan", sender: nil)
          }
        }
      })
      createAlert()
    }
    catch let error as NSError {
      print("Ooops! Something went wrong: \(error)")
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      spinner.startAnimating()
      labelResults.isHidden = true
      
      // Base64 encode the image and create the request
      let binaryImageData = base64EncodeImage(pickedImage)
      createRequest(with: binaryImageData)
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
    UIGraphicsBeginImageContext(imageSize)
    image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    let resizedImage = UIImagePNGRepresentation(newImage!)
    UIGraphicsEndImageContext()
    return resizedImage!
  }
}


/// Networking

extension ScanViewController {
  func base64EncodeImage(_ image: UIImage) -> String {
    var imagedata = UIImagePNGRepresentation(image)
    
    // Resize the image if it exceeds the 2MB API limit
    if (imagedata?.count > 2097152) {
      let oldSize: CGSize = image.size
      let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
      imagedata = resizeImage(newSize, image: image)
    }
    
    return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
  }
  
  func createRequest(with imageBase64: String) {
    // Create our request URL
    
    var request = URLRequest(url: googleURL)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
    
    // Build our API request
    let jsonRequest = [
      "requests": [
        "image": [
          "content": imageBase64
        ],
        "features": [
          [
            "type": "LABEL_DETECTION",
            "maxResults": 10
          ],
        ]
      ]
    ]
    let jsonObject = JSON(jsonRequest)
    
    // Serialize the JSON
    guard let data = try? jsonObject.rawData() else {
      return
    }
    
    request.httpBody = data
    
    // Run the request on a background thread
    DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
  }
  
  func runRequestOnBackgroundThread(_ request: URLRequest) {
    // run the request
    
    let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
      guard let data = data, error == nil else {
        print(error?.localizedDescription ?? "")
        return
      }
      
      self.analyzeResults(data)
    }
    
    task.resume()
  }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

