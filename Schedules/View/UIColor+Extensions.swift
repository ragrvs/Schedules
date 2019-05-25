//
//  Color+Constants.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit
import ChameleonFramework

/// Color constants for the application.
extension UIColor {
    
    class var darkBlue: UIColor {
        return UIColor(hexString: "20357B") ?? .flatBlueDark
    }
    
    class var lightBlue: UIColor {
        return UIColor(hexString: "338DAF") ?? .flatBlue
    }
    
}
