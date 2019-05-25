//
//  Store.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseMessaging
import FirebaseFunctions
import RealmSwift

/// Represents a reponse from the server.
typealias JSON = [String : Any]

/// Is responsible for any communication that needs to be
/// done with the server.
class Store {
    
    /// Only instance that is available during the lifecycle.
    static let shared = Store()
    
    /// Firebase is used for the server.
    private let _firebase = Database.database()
    
    /// Functions is used for instense processing.
    private let _functions = Functions.functions()
    
    /// Realm is used for disk persistance.
    private let _realm = try! Realm()
    
    /// Messaging is used for remote notifications.
    private let _messaging = Messaging.messaging()
    
    /// Singleton pattern....
    private init() {}
    
    /// Returns settings loaded either from disk or the server.
    func loadSetting(_ completion: @escaping (_ setting: SettingModel) -> Void) {
        
        // If the settings are loaded from disk
        if let setting = _realm.object(ofType: SettingModel.self) {
            
            NSLog("Setting loaded from disk")
            
            completion(setting)
        }
        // Settings are not on disk, we must retrieve them from
        // the server.
        else {
            
            downloadSquadrons { squadrons in
                
                // We now have the squadrons, lets persist the settings
                let setting = SettingModel()
                setting.squadrons = squadrons.sorted(by: <).toList()
                setting.squadron = setting.squadrons.first!
                
                // Persist setting on disk
                self._realm.writeDiscardError(setting)
                
                NSLog("Setting loaded from server")
                
                completion(setting)
            }
        }
    }
    
    /// Downloads all the squadrons from the server.
    /// NOTE: This fucntion can be implmemented on Firebase Functions
    /// for better performance.
    func downloadSquadrons(_ completion: @escaping (_ squadrons: [String]) -> Void) {
        
        _firebase.reference(withPath: "squadrons")
            .queryOrderedByKey()
            .observe(.value) { snapshot  in
                
                guard let squadronJSON = snapshot.value as? JSON else {
                    completion([])
                    return
                }
                
                let squadrons = squadronJSON.map { (key, _) in key }
                completion(squadrons)
        }
        
    }
    
    /// Downloads the events from the server for the specified date and squadron.
    func downloadEvents(squadron: String, date: String,
                        _ completion: @escaping (_ events: [EventModel]) -> Void) {
        
        _firebase.reference(withPath: "squadrons")
            .child(squadron)
            .child(date)
            .child("events")
            .observe(.value) { snapshot in
                
                guard let eventsJSON = snapshot.value as? [JSON] else {
                    completion([])
                    return
                }
                
                let events = eventsJSON.map(EventModel.init)
                completion(events)
        }
    }
    
    /// Downloads the chart data from the server for the specified squadron and name.
    ///
    func downloadChartData(setting: SettingViewModel, forLastDays days: Int,
                           completion: @escaping (_ hoursPerDay: [HoursPerDay]) -> Void) {
        
        // parameters for the `downloadChartData` firebase cloud function
        let data: [String: Any] = [
            "squadron": setting.squadronForAPI,
            "days": days,
            "name": setting.fullName
        ]
        
        _functions.httpsCallable("downloadChartData").call(data) { result, error in
            
            guard let hoursPerDayJSON = result?.data as? JSON else {
                completion([])
                return
            }
            
            // We must sort the days here so they are added to the `hoursPerDay`
            // in sorted order by day.
            let days = hoursPerDayJSON.map { day, hours in day } .sorted(by: <)
            
            // Simple uses the days sorted array to populate `hoursPerDay` in sorted
            // order by day.
            let hoursPerDay: [HoursPerDay] = days
                .map { day in HoursPerDay(hours: hoursPerDayJSON[day], day: day) }
                .compactMap { hoursPerDay in hoursPerDay }
            
            completion(hoursPerDay)
        }
    }
    
    /// Unsubscribes from the given squadron
    /// Firebase does not allow for `+` char in topic names. Thefore,
    /// we must replace the `+` with a valid char such as `-`
    func unsubscribe(fromSquadron squadron: String) {
        
        let sanitizedSquadron = sanitize(squadron)
        _messaging.unsubscribe(fromTopic: sanitizedSquadron, completion: { error in
            NSLog("Unsubscribed from: \(sanitizedSquadron)")
        })
    }
    
    /// Subscribes to the given topic
    /// Firebase does not allow for `+` char in topic names. Thefore,
    /// we must replace the `+` with a valid char such as `-`
    func subscribe(toSquadron squadron: String) {
        
         let sanitizedSquadron = sanitize(squadron)
        _messaging.subscribe(toTopic: sanitizedSquadron, completion: { error in
            NSLog("Subscribed to: \(sanitizedSquadron)")
        })
    }
    
    /// Replace `+` with `-`, otherwise leave squadron unchanged
    private func sanitize(_ squadron: String) -> String {
        return squadron.replacingOccurrences(of: "+", with: "-")
    }
}
