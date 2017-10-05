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
  var preferencePlist = "UserPrefs"
  var themesPlist = "ThemesList"
  var couldConnect: Bool!
  
  // user info and preferences
  var userNameKey = "userName"
  var userIDKey = "userID"
  var userEmailKey = "userEmail"
  var userGenderKey = "userGender"
  var userSelectedTheme = String()
  var firstRun = Bool()
  
  // style preferences
  var headerBarColour = String()
  var headerTextColour = String()
  var bodyTextColour = "0x3E3C3D"
  var textHighlightColour = String()
  var highlightedTextColour = String()
  
  // database reference
  var databaseRef: DatabaseReference!
  
  // link to AppDelgate
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  @IBAction func goToMain(segue:UIStoryboardSegue){
  }
  
  @IBOutlet weak var homeViewBar: UIView!
  @IBOutlet weak var userPhoto: UIImageView!
  @IBOutlet weak var usersNameLabel: UILabel!
  
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
    
    guard let firstRun = plistManager.fetchValue(for: "firstRun", fromPlistWithName: preferencePlist) as! Bool! else { return }
    print("App has run at least once?  \(firstRun)")
    
    if !(firstRun) {
      print("This is the first time the app has been launched.")
      saveToUserPlist()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // get theme name from plist
    guard let themeName = plistManager.fetchValue(for: "selectedAppTheme", fromPlistWithName: preferencePlist) as! String! else { return }
    
    // get colours from the respective theme
    guard let headerBarColour = plistManager.fetchValue(for: "headerBarColour", fromPlistWithName: themeName) as! String! else { return }
    guard let headerTextColour = plistManager.fetchValue(for: "headerTextColour", fromPlistWithName: themeName) as! String! else { return }
    
    // check if we should use the "light" status bar or not
    guard let statusBarCheck = plistManager.fetchValue(for: "useLightStatusBar", fromPlistWithName: themeName) as! Bool! else { return }
    
    // get user's name
    guard let usersName = plistManager.fetchValue(for: "userName", fromPlistWithName: preferencePlist) as! String! else { return }
    if (statusBarCheck) {
      UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // user photo stuff
    userPhoto.contentMode = .scaleAspectFit
    userPhoto.layer.borderWidth = 0.1
    userPhoto.layer.borderColor = UIColor().hexToColour(hexString: "0xFFFFFF", alpha: 0.0).cgColor
    userPhoto.layer.cornerRadius = userPhoto.frame.height/2
    userPhoto.layer.masksToBounds = false
    userPhoto.clipsToBounds = true
    
    usersNameLabel.text = usersName
    usersNameLabel.textColor = UIColor().hexToColour(hexString: headerTextColour)
    homeViewBar.backgroundColor = UIColor().hexToColour(hexString: headerBarColour)
    
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    let dirPath = paths.first
    let imageUrl = URL(fileURLWithPath: dirPath!).appendingPathComponent("\(String(describing: self.appDelegate.googleUsersId)).png")
    
    guard let gProfilePhotoUrl = plistManager.fetchValue(for: "userPhotoUrl", fromPlistWithName: preferencePlist) as! String! else { return }
    let onlinePhotoUrl = URL(string: gProfilePhotoUrl)
    
    if (try? self.downloadUserImage(url: onlinePhotoUrl!)) != nil {
      self.userPhoto.image = UIImage(contentsOfFile: imageUrl.path)
    } else {
      self.userPhoto.image = UIImage(named: "noUserImage")
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // create database reference
    databaseRef = Database.database().reference()
  }
  // save data to user plist
  func saveToUserPlist() {
    plistManager.save(self.appDelegate.googleUsersId, forKey: userIDKey, toPlistWithName: preferencePlist) { (err) in
      if err == nil { return }
    }
    
    plistManager.save(self.appDelegate.googleUsersName, forKey: userNameKey, toPlistWithName: preferencePlist) { (err) in
      if err == nil { return }
    }
    
    plistManager.save(self.appDelegate.googleUsersEmail, forKey: userEmailKey, toPlistWithName: preferencePlist) { (err) in
      if err == nil { return }
    }
    
    plistManager.save(true, forKey: "firstRun", toPlistWithName: preferencePlist) { (err) in
      if err == nil { return }
    }
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
