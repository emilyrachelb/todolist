//
//  UserProfileViewController.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-10-15.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import HealthKit
import SwiftyPlistManager
import Alamofire
import AlamofireImage

class UserProfileViewController: UINavigationController, UINavigationControllerDelegate {
  // global variables
  var plistManager = SwiftyPlistManager.shared
  var userPrefs = "UserPrefs"
  var userID = String()
  var userName = String()
  var userEmail = String()
  var userPhotoUrl: URL!
  
  // style preferences
  var headerBarColour = String()
  var headerTextColour = String()
  var bodyTextColour = "0x3E3C3D"
  var textHighlightColour = String()
  
  // link to appdelegate
  var appdelegate = UIApplication.shared.delegate as! AppDelegate
  
  // FIRDatabase reference
  var dbRef: DatabaseReference!
  
  // MARK: Properties
  @IBOutlet weak var navItem: UINavigationItem?
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var userAvatar: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var editProfileButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // get theme name
    guard let themeName = plistManager.fetchValue(for: "selectedAppTheme", fromPlistWithName: userPrefs) as! String! else { return }
    
    // get theme colours
    guard let headerBarColour = plistManager.fetchValue(for: "headerBarColour", fromPlistWithName: themeName) as! String! else { return }
    guard let headerTextColour = plistManager.fetchValue(for: "headerTextColour", fromPlistWithName: themeName) as! String! else { return }
    guard let textHighlightColour = plistManager.fetchValue(for: "textHighlightColour", fromPlistWithName: themeName) as! String! else { return }
    
    // check for light status bar
    guard let statusBarCheck = plistManager.fetchValue(for: "useLightStatusBar", fromPlistWithName: themeName) as! Bool! else { return }
    if (statusBarCheck) {
      UIApplication.shared.statusBarStyle = .lightContent
      
    }
    
    // set view controller background
    view.backgroundColor = UIColor.white
    view.isOpaque = true
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // retrieve all of the stored user data
    retrieveUserInfo()
    
    // Download the user's image
    Alamofire.request(userPhotoUrl).responseImage { response in
      debugPrint(response)
      
      print(response.request)
      print(response.response)
      debugPrint(response.result)
      
      if let image = response.result.value {
        print("image downloaded: \(image)")
        let photoSize = CGSize(width: 40, height: 40)
        let scaledToFit = image.af_imageAspectScaled(toFit: photoSize)
        self.userAvatar.image = scaledToFit.af_imageRoundedIntoCircle()
      }
    }
    
    userNameLabel.textColor = UIColor().hexToColour(hexString: headerTextColour)
    userNameLabel.text = userName
    
    editProfileButton.titleLabel?.textColor = UIColor().hexToColour(hexString: textHighlightColour)
    editProfileButton.addTarget(self, action: #selector(UserProfileViewController.editProfileButtonPressed), for: UIControlEvents.touchUpInside)
    
  }
  
  // retrieve stored user data
  // retrieve user data
  func retrieveUserInfo() {
    userID = plistManager.fetchValue(for: "userID", fromPlistWithName: userPrefs) as! String!
    userName = plistManager.fetchValue(for: "userName", fromPlistWithName: userPrefs) as! String!
    userEmail = plistManager.fetchValue(for: "userEmail", fromPlistWithName: userPrefs) as! String!
    userPhotoUrl = URL(string: plistManager.fetchValue(for: "userPhoto", fromPlistWithName: userPrefs) as! String!)
  }
  
  // edit profile button action controller
  func editProfileButtonPressed() {
    print("Edit profile button was pressed!")
  }
  
  // done button was presed
  func doneButtonPressed() {
    print("done button was pressed")
    
  }
}
