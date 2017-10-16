//
//  SettingsViewController.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-10-04.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftyPlistManager
import HealthKit

class SettingsViewController: UINavigationController, UINavigationControllerDelegate {
  
  // global variables
  var plistManager = SwiftyPlistManager.shared
  var userPrefs = "UserPrefs"
  var themesPlist = "ThemesList"
  
  // style preferences
  var headerBarColour = String()
  var headerTextColour = String()
  var bodyTextColour = "0x3E3C3D"
  var textHighlightColour = String()
  var highlightedTextColour = String()
  
  // link to appdelegate
  var appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  // MARK: Properties
  @IBOutlet weak var navItem: UINavigationItem?
  @IBOutlet weak var doneButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // get theme name
    guard let themeName = plistManager.fetchValue(for: "selectedAppTheme", fromPlistWithName: userPrefs) as! String! else { return }
    // get theme colours
    guard let headerBarColour = plistManager.fetchValue(for: "headerBarColour", fromPlistWithName: themeName) as! String! else { return }
    guard let headerTextColour = plistManager.fetchValue(for: "headerTextColour",fromPlistWithName: themeName) as! String! else { return }
    // check for "light" status bar
    guard let statusBarCheck = plistManager.fetchValue(for: "useLightStatusBar", fromPlistWithName: themeName) as! Bool! else { return }
    if (statusBarCheck) {
      UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // set view controller background colour
    view.backgroundColor = UIColor.white
    view.isOpaque = true
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let doneButton: UIButton = UIButton(type: UIButtonType.custom)
    doneButton.setTitle("Done", for: UIControlState.normal)
    doneButton.titleLabel?.textColor = UIColor().hexToColour(hexString: self.headerTextColour)
    doneButton.addTarget(self, action: #selector(SettingsViewController.doneButtonPressed), for: .touchUpInside)
    let doneButtonItem = UIBarButtonItem(customView: doneButton)
    self.navItem?.rightBarButtonItem = doneButtonItem
    
    self.navigationBar.tintColor = UIColor().hexToColour(hexString: self.headerTextColour)
  }
  
  func doneButtonPressed() {
    performSegue(withIdentifier: "unwindSegueToHomeVC", sender: self)
  }
}
