//: Playground - noun: a place where people can play

import Foundation

extension Date {
    var lastYear: Date {
        return Calendar.current.date(byAdding: .year, value: -1, to: self)!
    }
    
    var lastMonth: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
    
    var lastWeek: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)!
    }
    var today: Date {
        return Date()
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var nextWeek: Date {
        return Calendar.current.date(byAdding: .day, value: 7, to: self)!
    }
    
    var nextYear: Date {
        return Calendar.current.date(byAdding: .year, value: 1, to: self)!
    }
    
}

