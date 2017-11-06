//
//  GenderStringRepresentation.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-11-01.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

import HealthKit

extension HKBiologicalSex {
  var stringRepresentation: String {
    switch self {
    case .female:
      return "female"
    case .male:
      return "female"
    case .other:
      return "other"
    case .notSet:
      return "not set"
    }
  }
}
