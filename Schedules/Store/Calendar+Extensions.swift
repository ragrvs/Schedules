//
//  Calendar+Extensions.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import Foundation
import EventKit


/// Extension is merely used for syntatic sugar.
extension EKEventStore {
    
    /// Add the given event to calendar with the given date.
    static func addToCalendar(event: EventViewModel, date: Date,
                              completion: ((_ error: Error?) -> Void)?) {
        
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { accessGranted, error in
            
            if accessGranted {
                
                let eventItem = EKEvent(eventStore: eventStore, for: event, with: date)
                
                // Save event
                do {
                    try eventStore.save(eventItem, span: .thisEvent)
                    completion?(nil)
                } catch {
                    completion?(EventStoreError("Could not save event..."))
                }
                
            } else {
                completion?(EventStoreError("Access to Calendar denied..."))
            }
        }
    }

}


/// Extension is merely used for syntatic sugar.
extension EKEvent {
    
    /// Creates an event item for the given event with the date given.
    convenience init(eventStore: EKEventStore, for event: EventViewModel, with date: Date) {
        self.init(eventStore: eventStore)
        
        title = event.event.isEmpty ? "CNATRA Schedules" : event.event
        startDate = date.startDate(for: event)
        endDate = date.endDate(for: event)
        notes = event.instructorName.isEmpty ? "" : "Instructor: \(event.instructorName)"
        calendar = eventStore.defaultCalendarForNewEvents
    }
    
}

/// Extension is merely used for syntatic sugar.
extension Date {
    
    /// Returns a start `Date` for the given event
    func startDate(for event: EventViewModel) -> Date? {
        // Nice, `DateViewModel` already has an API for 'yyyy-MM-dd'
        // and event has an API for 'HH:mm'
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        // Use estimated departure time if there is not departure time
        let startTime = event.brief.isEmpty ? event.estimatedDepartureTime : event.brief
        
        return formatter.date(from: "\(self.yyyyMMdd()) \(startTime)")
    }
    
    /// Returns an end `Date` for the given event
    func endDate(for event: EventViewModel) -> Date? {
        // Nice, `DateViewModel` already has an API for 'yyyy-MM-dd'
        // and event has an API for 'HH:mm'
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        // Use estimated departure time if there is not return to base
        let endTime = event.returnToBaseTime.isEmpty ?
            event.estimatedDepartureTime : event.returnToBaseTime
        
        return formatter.date(from: "\(self.yyyyMMdd()) \(endTime)")
    }
}

/// Describes an error that occurs when attempting to add event to a calendar.
struct EventStoreError: Error {
    
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

extension EventStoreError: LocalizedError {
    
    /// A localized message describing what error occurred
    var errorDescription: String? {
        return message
    }
    
}
