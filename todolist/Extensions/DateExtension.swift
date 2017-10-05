//
//  DateExtension.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-10-04.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

import Foundation

extension Date {
  var lastYear: Date {
    return Calendar.current.date(byAdding: .day, value: -365, to: self)!
  }
  
  var tomorrow: Date {
    return Calendar.current.date(byAdding: .day, value: 1, to: self)!
  }
  
  var nextWeek: Date {
    return Calendar.current.date(byAdding: .day, value: 7, to: self)!
  }
}
