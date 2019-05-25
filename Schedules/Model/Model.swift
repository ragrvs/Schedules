//
//  Model.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - EventModel

/// Merely represents an event retrieved from the server.
/// Use `EventViewModel` for useful functionality
struct EventModel {
    var student: String                 = ""
    var instructor: String              = ""
    var type: String                    = ""
    var squadron: String                = ""
    var event: String                   = ""
    var location: String                = ""
    var remarks: String                 = ""
    var brief: String                   = ""
    var estimatedDepartureTime: String  = ""
    var returnToBaseTime: String        = ""
    var hours: String                   = ""
}

extension EventModel {
    
    /// Initializes an `EventModel` from `JSON`.
    /// Leading and trailling whitespaces are trim
    init(fromJSON json: JSON) {
        student                 = String(json["student"])?.trimWhitespaces()    ?? ""
        instructor              = String(json["instructor"])?.trimWhitespaces() ?? ""
        type                    = String(json["type"])?.trimWhitespaces()       ?? ""
        squadron                = String(json["vt"])?.trimWhitespaces()         ?? ""
        event                   = String(json["event"])?.trimWhitespaces()      ?? ""
        location                = String(json["location"])?.trimWhitespaces()   ?? ""
        brief                   = String(json["brief"])?.trimWhitespaces()      ?? ""
        estimatedDepartureTime  = String(json["edt"])?.trimWhitespaces()        ?? ""
        returnToBaseTime        = String(json["rtb"])?.trimWhitespaces()        ?? ""
        hours                   = String(json["hrs"])?.trimWhitespaces()        ?? ""
    }
    
}



// MARK: - SettingModel

/// Represent the settings stored on disk.
class SettingModel: Object {
    @objc dynamic var id: String        = "0"
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String  = ""
    @objc dynamic var squadron: String  = ""
    var squadrons: List<String>         = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension SettingModel {
    
    /// Initializes a setting given the first name, last name, squadron, andd squadrons.
    convenience init(firstName: String, lastName: String, squadron: String, squadrons: List<String>) {
        self.init()
        self.firstName  = firstName
        self.lastName   = lastName
        self.squadron   = squadron
        self.squadrons  = squadrons
    }
}

// MARK: - Hours Per Day

/// Represents chart data to be graphed.
struct HoursPerDay {
    
    var hours: Double
    
    /// day is a `Date` so it may offer more flexibility for
    /// representation
    var day: Date
}

extension HoursPerDay {
    
    /// Initializes hours per day given a castable hours
    /// and day to `Double` and `String`, respectively.
    init?(hours: Any?, day: String) {
        
        guard let hours = (hours as? Double)?.rounded(toPlaces: 1) else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let day = dateFormatter.date(from: day) else {
            return nil
        }
        
        self.hours = hours
        self.day = day
    }
    
    var description: String {
        return """
        HoursPerDay: {
            hours: \(hours)
            day: \(day)
        """
    }
}

// MARK: - String+Extensions

extension String {
    
    /// Initializes a `String` from a castable `Any`.
    init?(_ any: Any?) {
        
        // Cast it to string
        guard let string = any as? String else {
            return nil
        }
        
        self.init(string)
    }
    
    /// Trims whitespaces from left and right end of the string.
    func trimWhitespaces() -> String {
        return trimmingCharacters(in: .whitespaces)
    }
}

// MARK: - Double+Extensions

extension Double {
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
