//
//  SignInViewController.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-10-02.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

// import require frameworks
import UIKit
import HealthKit
import Firebase
import GoogleSignIn
import SwiftyPlistManager

// start SignInController class

class SignInViewController: UIViewController, GIDSignInUIDelegate {
  
  // global variables
  var preferencesArray: NSMutableArray!
  var plistPath: String!
  
  // MARK: Properties
  @IBOutlet weak var googleSignInButton: GIDSignInButton!
  
  // set read properties for healthkit
  var healthStore: HKHealthStore?
  private let dataTypesToRead: NSSet = {
    let healthKitManager = HealthKitManager.sharedInstance
    return NSSet(objects:
        healthKitManager.biologicalSexCharacteristic,
        healthKitManager.dateOfBirthCharacteristic,
        healthKitManager.qualitativeActivitySummary,
        healthKitManager.qualitativeUsersSleepActivity,
        healthKitManager.quantitativeUsersStepCount)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // google signin
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().signInSilently() // checks if the user is already signed in
    
    // configure the google signin button
    googleSignInButton.style = GIDSignInButtonStyle.wide
    
    // authorize healthkit
    HealthKitManager.sharedInstance.requestHealthKitAuthorization(dataTypesToWrite: nil, dataTypesToRead: dataTypesToRead)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
      print("user signed in")
      self.performSegue(withIdentifier: "goToMain", sender: nil)
    } else {
      print ("user not signed in")
    }
  }

}
