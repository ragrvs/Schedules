//
//  DateViewModel.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import Foundation

extension Date {
    
    /// Returns a date formatted in the following format: `yyyy-MM-dd`
    /// (i.e **2019-04-30**).
    func yyyyMMdd() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    /// Returns a date formatted in the following format: `EEEE, MMM d, yyyy`
    /// (i.e **Wednesday, May 8, 2019**)
    func mondayJan102019() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
    
    /// Returns a date formatters in the following format: Jan 1
    func jan10() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
}
