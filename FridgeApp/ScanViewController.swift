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

class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let imagePicker = UIImagePickerController()
  let session = URLSession.shared
  var itemArray = [String.SubSequence]()
  var fridgeItems = [FridgeItem]()
  
//  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var labelResults: UITextView!
  
  weak var delegate: ManuallyAddViewControllerDelegate?
  
  var googleAPIKey = "AIzaSyAWNssKrhgP9TgMwRUPvnK3g-vL8dKZBpU"
  var googleURL: URL {
    return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
  }
  
  @IBAction func loadImageButtonTapped(_ sender: UIButton) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .photoLibrary
    
    present(imagePicker, animated: true, completion: nil)
  }
  
//  @IBAction func takePhoto(){
//    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//      let imagePicker = UIImagePickerController()
//      imagePicker.delegate = self
//      imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//      imagePicker.allowsEditing = false
//      self.present(imagePicker, animated: true, completion: nil)
//    }
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //      let image = UIImage(named: "apple.jpg")
    //      let binaryImageData = base64EncodeImage(image!)
    //      createRequest(with: binaryImageData)
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
//      self.imageView.isHidden = true
      self.labelResults.isHidden = false
      
      // Check for errors
      if (errorObj.dictionaryValue != [:]) {
        self.labelResults.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
      } else {
        // Parse the response
        //                print(json)
        let responses: JSON = json["responses"][0]
        
        // Get label annotations
        let labelAnnotations: JSON = responses["labelAnnotations"]
        let numLabels: Int = labelAnnotations.count
        var labels: Array<String> = []
        if numLabels > 0 {
          var labelResultsText:String = ""//"Labels found: "
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
  
  func identifyItem (APIresults: String) {
    //search words in txt file
//    let userPath = "/Users/sbauerthp/Documents/IOSApp/Fridge App/67442-project/FridgeApp" //ADD PATH TO SWIFT FOLDER HERE
    let userPath = Bundle.main.path(forResource: "foodExpiration", ofType: "txt")
//    let file = "\(userPath)/foodExpiration.txt"
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
    }
    catch let error as NSError {
      print("Ooops! Something went wrong: \(error)")
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//      imageView.contentMode = .scaleAspectFit
//      imageView.isHidden = true // You could optionally display the image here by setting imageView.image = pickedImage
      //imageView.image = pickedImage
      spinner.startAnimating()
      labelResults.isHidden = true
      
      //             Base64 encode the image and create the request
      let binaryImageData = base64EncodeImage(pickedImage)
      // hard coding image in
      //          let image = UIImage(named: "avacado.jpg")
      //          let binaryImageData = base64EncodeImage(image!)
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

