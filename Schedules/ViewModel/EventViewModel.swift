//
//  EventViewModel.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import Foundation
import Firebase

// MARK: - EventViewModel

/// Encapsulates `EventModel` providing it extra functionanlity and
/// custom getters and setters.
struct EventViewModel {
    
    private let _event: EventModel
    
    var student: String {
        return _event.student
    }
    
    var instructor: String {
        return _event.instructor
    }
    
    var type: String {
        return _event.type
    }
    
    var squadron: String {
        return _event.squadron
    }
    
    var event: String {
        return _event.event
    }
    
    var location: String {
        return _event.location
    }
    
    var remarks: String {
        return _event.remarks
    }
    
    var brief: String {
        return _event.brief
    }
    
    var estimatedDepartureTime: String {
        return _event.estimatedDepartureTime
    }
    
    var returnToBaseTime: String {
        return _event.returnToBaseTime
    }
    
    var hours: String {
        return _event.hours.isEmpty ? "" : "\(_event.hours)h"
    }
    
    /// Cast hours to double
    var hoursAsDouble: Double? {
        return Double(_event.hours)
    }
    
    /// Returns the full instructor `Name`
    var instructorName: String {
        return _fullName(name: _event.instructor)
    }
    
    /// Returns the full student `Name`
    var studentName: String {
        return _fullName(name: _event.student)
    }
    
    /// Parses the given name retrieve from the server for its `firstname` and `lastName`
    private func _fullName(name: String) -> String {
        
        // We may have empty names
        if name.isEmpty { return "" }
        
        // TAYLOR, MICHAEL [CIV]
        let split = name.split(separator: ",")
        
        // We may have names such as `SOLO`
        if split.count == 1 { return split[0].description }
        
        let firstName = split[1].split(separator: " ")[0].description
        let lastName = split[0].description
        
        if firstName.isEmpty || lastName.isEmpty {
            return firstName + lastName
        } else {
            return firstName + " " + lastName
        }
    }
    
    var description: String {
        return """
        EventViewModel: {
            student: \(student)
            instructor: \(instructor)
            type: \(type)
            squadron: \(squadron)
            event: \(event)
            location: \(location)
            remarks: \(remarks)
            brief: \(brief)
            estimatedDepartureTime: \(estimatedDepartureTime)
            returnToBaseTime: \(returnToBaseTime)
            hours: \(hours)
        """
    }
}

extension EventViewModel {
    
    /// Intializes `EventViewModel` from the given `event`
    init(event: EventModel) {
        _event = EventModel(
            student:                event.student,
            instructor:             event.instructor,
            type:                   event.type,
            squadron:               event.squadron,
            event:                  event.event,
            location:               event.location,
            remarks:                event.remarks,
            brief:                  event.brief,
            estimatedDepartureTime: event.estimatedDepartureTime,
            returnToBaseTime:       event.returnToBaseTime,
            hours:                  event.hours)
    }
    
}

// MARK: - EventViewModel + Comparable

extension EventViewModel: Comparable {
    
    static func == (lhs: EventViewModel, rhs: EventViewModel) -> Bool {
        return  lhs.student == rhs.student &&
                lhs.instructor == rhs.instructor &&
                lhs.type == rhs.type &&
                lhs.squadron == rhs.squadron &&
                lhs.event == rhs.event &&
                lhs.brief == rhs.brief &&
                lhs.estimatedDepartureTime == rhs.estimatedDepartureTime &&
                lhs.returnToBaseTime == rhs.returnToBaseTime &&
                lhs.hours == rhs.hours
    }
    
    static func < (lhs: EventViewModel, rhs: EventViewModel) -> Bool {
        if lhs.student.isEmpty { return false }
        if rhs.student.isEmpty { return true }
        
        return lhs.student < rhs.student
    }
    
}

// MARK: - Array+Extensions

extension Array where Element == EventViewModel {
    
    /// Filters the students that contain the given student name.
    func filter(withStudent student: String) -> [EventViewModel] {
        return filter { $0.studentName.localizedCaseInsensitiveContains(student) }
    }
    
    /// Filters the instructors that contain the given instructor name.
    func filter(withInstructor instructor: String) -> [EventViewModel] {
        return filter { $0.instructorName.localizedCaseInsensitiveContains(instructor) }
    }
    
    /// Filters the instructors or students that contain the given name.
    func filter(withStudentOrInstructor name: String) -> [EventViewModel] {
        let students = filter(withStudent: name)
        let instructors = filter(withInstructor: name)
        
        return students + instructors
    }
}
