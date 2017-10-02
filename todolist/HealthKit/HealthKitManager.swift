//
//  HealthKitManager.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-10-02.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
  class var sharedInstance: HealthKitManager {
    struct Singleton {
      static let instance = HealthKitManager()
    }
    return Singleton.instance
  }
  
  var healthStore: HKHealthStore? = {
    if HKHealthStore.isHealthDataAvailable() {
      return HKHealthStore()
    } else {
      return nil
    }
  }()
  
  // health kit data that needs to be read
  let dateOfBirthCharacteristic = HKCharacteristicType.characteristicType(forIdentifier: .dateOfBirth)
  let biologicalSexCharacteristic = HKCharacteristicType.characteristicType(forIdentifier: .biologicalSex)
  let qualitativeUsersSleepActivity = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)
  let quantitativeUsersStepCount = HKQuantityType.quantityType(forIdentifier: .stepCount)
  let qualitativeActivitySummary = HKActivitySummaryType.activitySummaryType()
  
  var dateOfBirth: String {
    if let dateOfBirth = try? healthStore?.dateOfBirthComponents() {
      let birthdateDateFormatter = DateFormatter()
      birthdateDateFormatter.dateStyle = .long
      let preferredDateFormat = Calendar.current.date(from: dateOfBirth!)!
      let birthdate = birthdateDateFormatter.string(from: preferredDateFormat)
      return birthdate
    }
    // prevent errors thrown with "optional nil value"
    return ""
  }
  
  var biologicalSex: String {
    if let biologicalSex = try? healthStore?.biologicalSex() {
      switch biologicalSex!.biologicalSex {
      case .female:
        return "female"
      case .male:
        return "male"
      case .other:
        return "other"
      case .notSet:
        return "not_set"
      }
    }
    return "not_set"
  }
  
  var healthKitAuthorized: Bool? {
    return nil
  }
  
  func requestHealthKitAuthorization(dataTypesToWrite: NSSet?, dataTypesToRead: NSSet?) {
    healthStore?.requestAuthorization(toShare: dataTypesToWrite as? Set<HKSampleType>, read: dataTypesToRead as? Set<HKObjectType>, completion: {(success, error) -> Void in
      if success {
        print ("Successfully authorized HealthKit")
        let healthKitAuthorized = true
      } else {
        print (error?.localizedDescription)
      }
    })
  }
  
  class func getMostRecentSample(for sampleType: HKSampleType, completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
    // use hkquery to load the most recent samples
    let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date().tomorrow, options: .strictEndDate)
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
    
    let limit = 1
    
    let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
      DispatchQueue.main.async {
        guard let samples = samples, let mostRecentSample = samples.first as? HKQuantitySample else {
          completion(nil, error)
          return
        }
        completion(mostRecentSample, nil)
      }
    }
    HKHealthStore().execute(sampleQuery)
  }
}

extension Date {
  var lastYear: Date {
    return Calendar.current.date(byAdding: .day, value: -365, to: self)!
  }
  
  var tomorrow: Date {
    return Calendar.current.date(byAdding: .day, value: 1, to: self)!
  }
}
