//
//  TodaysTaskListViewController.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-10-11.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

import Foundation
import UIKit
import SwiftyPlistManager

class TodaysTaskListViewController: UINavigationController, UINavigationBarDelegate {
  
  // global variable declaration
  var plistManager = SwiftyPlistManager.shared
  var userPrefs = "userPrefs"
  
  // MARK: Properties
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}
