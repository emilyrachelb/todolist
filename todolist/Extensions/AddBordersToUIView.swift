//
//  AddBordersToUIView.swift
//  todolist
//
//  Created by Samantha Emily-Rachel Belnavis on 2017-10-16.
//  Copyright © 2017 Samantha Emily-Rachel Belnavis. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  enum ViewSide {
    case Left, Right, Top, Bottom
  }
  
  func addBorder(toSide side: ViewSide, withColour color: CGColor, andThickness thickness: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color
    
    switch side {
    case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
    case .Right: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
    case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
    case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
    }
    
    layer.addSublayer(border)
  }
}
