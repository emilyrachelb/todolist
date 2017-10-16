//
//  UserProfileTableViewController.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-10-15.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

import Foundation
import UIKit
import SwiftyPlistManager
import Alamofire
import AlamofireImage

class UserProfileTableViewController: UITableViewController {
  // global variables
  var plistManager = SwiftyPlistManager.shared
  var userPrefs = "UserPrefs"
  var userID = String()
  var userName = String()
  var userEmail = String()
  var userPhotoUrl: URL!
  var textHighlightColour = String()
  
  // link to appdelegate
  var appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  // MARK: Properties
  @IBOutlet weak var userAvatar: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var editProfileButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // get theme name
    guard let themeName = plistManager.fetchValue(for: "selectedAppTheme", fromPlistWithName: userPrefs) as! String! else { return }
    
    guard let textHighlightColour = plistManager.fetchValue(for: "textHighlightColour", fromPlistWithName: themeName) as! String! else { return }
    
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
    
    usernameLabel.textColor = UIColor().hexToColour(hexString: textHighlightColour)
    usernameLabel.text = userName
    
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
}
