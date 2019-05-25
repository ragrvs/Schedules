//
//  Realm+Extensions.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import Foundation
import RealmSwift

/// Extension is merely used for syntatic sugar
/// and also to avoid dealing with errors
extension Realm {
    
    /// Retrieves a single instance of the given object type.
    func object<Element: SettingModel>(ofType type: Element.Type) -> Element? {
        return object(ofType: type, forPrimaryKey: "0")
    }
    
    /// Performs actions contained within the given block inside a write transaction.
    func writeDiscardError(_ block: (() throws -> Void)) {
        do {
            try write {
                try block()
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    }

    /// Persists the given settings to disk.
    func writeDiscardError(_ setting: SettingModel) {
        writeDiscardError {
            add(setting, update: true)
        }
    }
}

extension Array where Element: RealmCollectionValue {
    
    /// Creates a realm list from the given array containing realm elements.
    func toList() -> List<Element> {
        let list = List<Element>()
        list.append(objectsIn: self)
        return list
    }
}

extension List {
    
    /// Creates an array from the given list containing realm elements.
    func toArray() -> [Element] {
        return self.map{ $0 }
    }
}
