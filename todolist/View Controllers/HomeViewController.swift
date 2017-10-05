//
//  HomeViewController.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-10-02.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import HealthKit
import SwiftyPlistManager

class HomeViewController: UIViewController {

  // global variables
  var userID = String()
  var userName = String()
  var userEmail = String()
  var userDefaults = UserDefaults.standard
  var plistManager = SwiftyPlistManager.shared
  var preferencePlist = "Preferences"
  var themesPlist = "Themes"
  
  // style preferences
  var themeName = String()
  var headerBarColor = String()
  var headerTextColor = String()
  var bodyTextColor = "0x3E3C3D"
  var textHighlightColour = String()
  var highlightedTextColour = String()
  
  // database reference
  var databaseRef: DatabaseReference!
  
  // link to AppDelgate
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  // MARK: Properties
  @IBOutlet weak var homeViewBar: UIView!
  
  
  private enum IdentifyingDataFields: Int {
    case DateOfBirth, BiologicalSex
    
    func data() -> (title: String, value: String?) {
      let healthKitManager = HealthKitManager.sharedInstance
      
      switch self {
      case .DateOfBirth:
        return("Date of Birth", healthKitManager.dateOfBirth)
      case .BiologicalSex:
        return("Gender" , healthKitManager.biologicalSex)
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let themeName = plistManager.fetchValue(for: "selectedAppTheme", fromPlistWithName: preferencePlist) else { return }
    guard let headerBarColour = plistManager.fetchValue(for: , fromPlistWithName: themesPlist) else { return }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    plistManager.start(plistNames: ["Preferences"], logging: true)
    guard let headerBarColor = plistManager.fetchValue(for: headerBarColor, fromPlistWithName: preferencePlist) else { return }
    guard let headerBarText = plistManager.fetchValue(for: headerTextColor, fromPlistWithName: preferencePlist) else { return }
    guard let bodyTextColor = plistManager.fetchValue(for: bodyTextColor, fromPlistWithName: preferencePlist) else { return }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // create database reference
    databaseRef = Database.database().reference()
    
    
    
  }
  
  // get image from source asynchronously
  func getImageFromUrl(url: URL, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url) {
      (data, response, error) in
      completion(data, response, error)
      }.resume()
  }
  
  func downloadUserImage(url: URL) {
    print("Download started")
    getImageFromUrl(url: url) { (data, response, error) in
      guard let data = data, error == nil else { return }
      print ("Download finished")
      DispatchQueue.main.async { () -> Void in
        let userImageData = data
        // save to file
        let documentsDirectoryUrl = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("\(String(describing: self.appDelegate.googleUsersId)).png")
        
        do {
          try userImageData.write(to: fileUrl)
          print("Image was saved")
        } catch {
          print(error)
        }
      }
    }
  }
}
