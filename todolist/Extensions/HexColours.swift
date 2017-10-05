//
//  File.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-10-04.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  /*convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
    assert(red >= 0 && red <= 255, "Invalid red value")
    assert(green >= 0 && green <= 255, "Invalid green value")
    assert(blue >= 0 && blue <= 255, "Invalid blue value")
    
    self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha:(a))
  }
  
  convenience init(rgb: Int, a: CGFloat = 1.0) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 16) & 0xFF,
      blue: (rgb >> 16) & 0xFF,
      a: a
    )
  }*/
  
  func hexToColour(hexString: String, alpha: CGFloat? = 1.0) -> UIColor {
    let hexint =  Int(self.intFromHexString(hexStr: hexString))
    let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
    let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
    let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
    let alpha = alpha!
    
    let colour = UIColor(red: red, green: green, blue: blue, alpha: alpha)
    return colour
  }
  func intFromHexString(hexStr: String) -> UInt32 {
    var hexInt: UInt32 = 0
    
    let scanner: Scanner = Scanner(string: hexStr)
    scanner.scanHexInt32(&hexInt)
    return hexInt
  }
}
