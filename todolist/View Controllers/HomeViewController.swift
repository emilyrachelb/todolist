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
import GoogleSignIn
import HealthKit
import SwiftyPlistManager
import Alamofire
import AlamofireImage

class HomeViewController: UINavigationController, UINavigationControllerDelegate, GIDSignInUIDelegate{

  // global variables
  var plistManager = SwiftyPlistManager.shared
  var userPrefs = "UserPrefs"
  var themesPlist = "ThemesList"
  var couldConnect: Bool!
  
  // user info and preferences
  var userID = String()
  var userName = String()
  var userNameLabel: UILabel?
  var userEmail = String()
  //var userPhoto: UIImageView?
  var userPhotoUrl: URL!
  var userAvatarButtonItem: UIBarButtonItem!
  var userGender = String()
  var userSelectedTheme = String()
  var hasRunBefore = Bool()
  
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
  
  // MARK: Properties
  @IBOutlet weak var navItem: UINavigationItem?
  @IBOutlet weak var userAvatarButton: UIBarButtonItem!
  @IBOutlet weak var userNameButton: UIBarButtonItem!
  @IBOutlet weak var settingsButton: UIBarButtonItem!
  
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
  
  // check if we can reach the internet
  func checkInternet() {
    guard let status = Network.reachability?.status else { return }
    switch status {
    case .unreachable:
      print("Internet unreachable")
      return couldConnect = false
    case .wifi:
      print("Internet reachable")
      return couldConnect = true
    case .wwan:
      print("Internet reachable")
      return couldConnect = true
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().signInSilently()
    
    // get theme name from plist
    guard let themeName = plistManager.fetchValue(for: "selectedAppTheme", fromPlistWithName: userPrefs) as! String! else { return }
    
    // get colours from the respective theme
    guard let headerBarColour = plistManager.fetchValue(for: "headerBarColour", fromPlistWithName: themeName) as! String! else { return }
    guard let headerTextColour = plistManager.fetchValue(for: "headerTextColour", fromPlistWithName: themeName) as! String! else { return }
    
    // check if we should use the "light" status bar or not
    guard let statusBarCheck = plistManager.fetchValue(for: "useLightStatusBar", fromPlistWithName: themeName) as! Bool! else { return }
    if (statusBarCheck) {
      UIApplication.shared.statusBarStyle = .lightContent
    }
    
    view.backgroundColor = UIColor.white
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // database reference
    databaseRef = Database.database().reference()
    
    if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
      
      retrieveUserInfo()
      
      
      Alamofire.request(userPhotoUrl).responseImage { response in
        debugPrint(response)
        
        print(response.request)
        print(response.response)
        debugPrint(response.result)
        
        if let image = response.result.value {
          print("image downloaded: \(image)")
          //let circleAvatar = image.af_imageRoundedIntoCircle()
          let photoSize = CGSize(width: 30, height: 30)
          let scaledToFit = image.af_imageAspectScaled(toFit: photoSize)
          let circleAvatar = scaledToFit.af_imageRoundedIntoCircle()
          
          let userAvatarButton: UIButton = UIButton(type: UIButtonType.custom)
          userAvatarButton.setImage(circleAvatar, for: UIControlState.normal)
          userAvatarButton.addTarget(self, action: #selector(HomeViewController.userInfoButtonsPressed), for: UIControlEvents.touchUpInside)
          userAvatarButton.frame = CGRect(x: 0,  y: 0, width: 34, height: 34)
          //userAvatarButton.contentMode = .scaleAspectFit
          
          let userAvatarButtonItem = UIBarButtonItem(customView: userAvatarButton)
          
          let userNameButton: UIButton = UIButton(type: UIButtonType.custom)
          userNameButton.setTitle(self.userName, for: UIControlState.normal)
          userNameButton.titleLabel?.textColor = UIColor().hexToColour(hexString: self.headerTextColour)
          userNameButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
          userNameButton.addTarget(self, action: #selector(HomeViewController.userInfoButtonsPressed), for: UIControlEvents.touchUpInside)
          let userNameButtonItem = UIBarButtonItem(customView: userNameButton)
         
          self.navItem?.leftBarButtonItems = [userAvatarButtonItem, userNameButtonItem]
        }
      }
      let settingsButton: UIButton = UIButton(type: UIButtonType.custom)
      settingsButton.setImage(UIImage(named: "settings"), for: UIControlState.normal)
      settingsButton.addTarget(self, action: #selector(HomeViewController.settingsButtonPressed), for: UIControlEvents.touchUpInside)
      settingsButton.tintColor = UIColor().hexToColour(hexString: self.headerTextColour)
      settingsButton.frame = CGRect(x: 0, y:0, width: 10, height: 10)
      settingsButton.contentMode = .scaleAspectFit
      
      let settingsButtonItem = UIBarButtonItem(customView: settingsButton)
      self.navItem?.rightBarButtonItem = settingsButtonItem
      
      
    }

  }

  // left navbar item action controller
  func userInfoButtonsPressed() {
    print("User info buttons button was pressed!")
  }
  
  func settingsButtonPressed() {
    print("Settings button was pressed")
    performSegue(withIdentifier: "goToSettings", sender: self)
  }
  
  // retrieve user data
  func retrieveUserInfo() {
    userID = plistManager.fetchValue(for: "userID", fromPlistWithName: userPrefs) as! String!
    userName = plistManager.fetchValue(for: "userName", fromPlistWithName: userPrefs) as! String!
    userEmail = plistManager.fetchValue(for: "userEmail", fromPlistWithName: userPrefs) as! String!
    userPhotoUrl = URL(string: plistManager.fetchValue(for: "userPhoto", fromPlistWithName: userPrefs) as! String!)
  }

  @IBAction func unwindToHomeVC(segue:UIStoryboardSegue) {}
}
