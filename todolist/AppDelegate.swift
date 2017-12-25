//
//  AppDelegate.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-10-02.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import SwiftyPlistManager
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
  
  var window: UIWindow?
  
  // true: display debug info
  // false: don't display debug info
  var debugMode: Bool = true
  
  // app specific variables
  var connectionAvailable: Bool!
  var plistPathInDocument: String = String()
  let userDefaults = UserDefaults.standard
  let plistManager = SwiftyPlistManager.shared
  
  // plist list
  var userPrefs = "UserPrefs"
  var themesPlist = "ThemesList"
  
  // individual theme property lists
  var theme0 = "defaultTheme"
  var theme1 = "lightTheme"
  var theme2 = "darkTheme"
  var theme3 = "tangerineTheme"
  var theme4 = "sunflowerTheme"
  var theme5 = "cloverTheme"
  var theme6 = "blueberryTheme"
  var theme7 = "skyBlueTheme"
  var theme8 = "amethystTheme"
  var theme9 = "graphiteTheme"
  
  // user info variables
  var googleUserId = String()
  var googleUserName = String()
  var googleUserEmail = String()
  var googleUserPhoto = String()
  var userGender = String()
  var userAge = String()
  var userBirthday = String()
  
  // create database reference
  var databaseRef: DatabaseReference!
  
  // internet connectivity
  var internetConnected: Bool!
 
  // theme things
  var navbarAppearance = UINavigationBar.appearance()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // initialize firebase application
    FirebaseApp.configure()
    Database.database().isPersistenceEnabled = true
    
    // google login instance setup
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance().delegate = self
    
    plistManager.start(plistNames: [userPrefs, themesPlist, theme0, theme1, theme2, theme3, theme4, theme5, theme6, theme7, theme8, theme9], logging: true)
    
    // get the name of the currently selected theme
    let currentTheme = plistManager.fetchValue(for: "selectedAppTheme", fromPlistWithName: userPrefs) as! String!
    
    // get colours from theme file
    let headerBarColour = plistManager.fetchValue(for: "headerBarColour", fromPlistWithName: currentTheme!) as! String!
    let headerTextColour = plistManager.fetchValue(for: "headerTextColour", fromPlistWithName: currentTheme!) as! String!
    
    UINavigationBar.appearance().barTintColor = UIColor().hexToColour(hexString: headerBarColour!)
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor().hexToColour(hexString: headerTextColour!)]
    
    return true
  }
  
  func checkInternet() {
    guard let status = Network.reachability?.status else { return }
    switch status {
    case .unreachable:
      print ("Internet unreachable")
      return connectionAvailable = false
    case .wifi:
      print ("Internet reachable")
      return connectionAvailable = true
    case .wwan:
      print ("Internet reachable")
      return connectionAvailable = true
    }
  }
  
  func getIdentifyingHealthKitData() throws -> (age: Int, birthDate: String, gender: HKBiologicalSex) {
    // database reference
    self.databaseRef = Database.database().reference().child("user_profiles").child(self.googleUserId)
    
    let healthKitStore = HKHealthStore()
    do {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US")
      dateFormatter.setLocalizedDateFormatFromTemplate("MMM-dd-yyyy")
      
      let birthdayComponents = try healthKitStore.dateOfBirthComponents()
      let gender = try healthKitStore.biologicalSex()
      
      let today = Date()
      let calendar = Calendar.current
      let currentDateComponents = calendar.dateComponents([.year], from: today)
      
      let thisYear = currentDateComponents.year!
      let age = thisYear - birthdayComponents.year!
      let dateToDisplay = calendar.date(from: birthdayComponents)!
      let birthDate = dateFormatter.string(from: dateToDisplay)
      
      let unwrappedGender = gender.biologicalSex
      
      return (age, birthDate, unwrappedGender)
    }
  }
  
  func saveUserInfo() {
    self.databaseRef = Database.database().reference().child("user_profiles").child(self.googleUserId)
    
    self.databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
      let snapshot = snapshot.value as? NSDictionary
      
      // if values don't exist in the database, save them to the database
      // otherwise update the values
      if (snapshot == nil) {
        self.databaseRef.child("user_id").setValue(self.googleUserId)
        self.databaseRef.child("user_name").setValue(self.googleUserId)
        self.databaseRef.child("user_gender").setValue(self.userGender)
        self.databaseRef.child("user_age").setValue(self.userAge)
        self.databaseRef.child("user_birthday").setValue(self.userBirthday)
      }
    })
    
    // save to plist for offline functionality
    plistManager.save(self.googleUserId as String!, forKey: "user_id", toPlistWithName: userPrefs) { (err) in
      if (err == nil) { return }
    }
    plistManager.save(self.googleUserName as String!, forKey: "user_name", toPlistWithName: userPrefs) { (err) in
      if (err == nil) { return }
    }
    plistManager.save(self.googleUserEmail as String!, forKey: "user_email", toPlistWithName: userPrefs) { (err) in
      if (err == nil) { return }
    }
    plistManager.save(self.googleUserPhoto as String!, forKey: "user_photo_url", toPlistWithName: userPrefs) { (err) in
      if (err == nil) { return }
    }
    plistManager.save(self.userGender, forKey: "user_gender", toPlistWithName: userPrefs) { (err) in
      if (err == nil) { return }
    }
    plistManager.save(self.userAge, forKey: "user_age", toPlistWithName: userPrefs) { (err) in
      if (err == nil) { return }
    }
    plistManager.save(self.userBirthday, forKey: "user_birthday", toPlistWithName: userPrefs) { (err) in
      if (err == nil) { return }
     }
    
    if (debugMode) {
      debugPrint("User info was saved")
    }
  }
  
  func sign(_ signIn: GIDSignIn, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    if error != nil {
      return
    }
    
    guard let authentication = user.authentication else { return }
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    
    // retrieve details from the google user's profile
    googleUserId = user.userID
    googleUserName = user.profile.name
    googleUserEmail = user.profile.email
    googleUserPhoto = "\(String(describing: user.profile.imageURL(withDimension: 100 * UInt(UIScreen.main.scale))!))"
    let userIdentifyingInfo = try? getIdentifyingHealthKitData()
    let userGender = userIdentifyingInfo?.gender.stringRepresentation
    let userAge = userIdentifyingInfo?.age
    let userBirthday = userIdentifyingInfo?.birthDate
    
    if (debugMode == true) {
      debugPrint("retrieved userID: ", self.googleUserId)
      debugPrint("retrieved user_name: ", self.googleUserName)
      debugPrint("retrieved user_email: ", self.googleUserEmail)
      debugPrint("retrieved user_photo_url: ", self.googleUserPhoto)
      debugPrint("retrieved user_gender: ", userGender)
      debugPrint("retrieved user_age: ", userAge!)
      debugPrint("retrieved user_birthday: ", userBirthday)
    }
    
    // save information
    saveUserInfo()
    
    Auth.auth().signIn(with: credential) { (user, error) in
      if error != nil {
        return
      }
    }
    return
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }

  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
      // create / return container for appplication
      let container = NSPersistentContainer(name: "todolist")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }
  
  static func shared() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }

}

