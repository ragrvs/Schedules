//
//  SettingsViewModel.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import Foundation
import Firebase
import RealmSwift

/// Represents the setting delegate that will be notified when certain changes occur
protocol SettingDelegate {
    
    /// Called when the squadron is changed
    /// `oldValue` and `newValue` are lowercased for ease
    func didSquadronChange(_ setting: SettingViewModel, oldValue: String, newValue: String)
    
    /// Called when the `firstName` or `lastName` is changed
    func didNameChange(_ setting: SettingViewModel, oldValue: String, newValue: String)
}

/// Encapsulates `SettingModel` providing it extra functionanlity and
/// custom getters and setters.
class SettingViewModel {
    
    private let _setting: SettingModel
    private let _realm: Realm
    
    var delegate: SettingDelegate?
    
    init(setting: SettingModel, realm: Realm) {
        _setting = setting
        _realm = realm
    }
    
    var firstName: String {
        set {
            if firstName != newValue {
                
                // Grab reference to old value
                let oldValue = fullName
                
                // Persist new value to realm
                _realm.writeDiscardError {
                    _setting.firstName = newValue
                }
                
                // Notify changed name
                delegate?.didNameChange(self, oldValue: oldValue, newValue: fullName)
            }
        }
        get {
            return _setting.firstName.trimmingCharacters(in: .whitespaces)
        }
    }
    
    var lastName: String {
        set {
            if lastName != newValue {
                
                // Grab reference to old value
                let oldValue = fullName
                
                // Persist new value to realm
                _realm.writeDiscardError {
                    _setting.lastName = newValue
                }
                
                // Notify changed named
                delegate?.didNameChange(self, oldValue: oldValue, newValue: fullName)
            }
        }
        get {
            return _setting.lastName.trimmingCharacters(in: .whitespaces)
        }
    }
    
    var fullName: String {
        get {
            if firstName.isEmpty || lastName.isEmpty {
                return firstName + lastName
            } else {
                return firstName + " " + lastName
            }
        }
    }
    
    var squadron: String {
        set {
            if squadron != newValue {
                
                // Grab reference to old value
                let oldValue = squadron.lowercased()
                let newValue = newValue.lowercased()
                
                // Persist new value to realm
                _realm.writeDiscardError {
                    _setting.squadron = newValue
                }
                
                // Notify squadron changed
                delegate?.didSquadronChange(self, oldValue: oldValue, newValue: newValue)
            }
        }
        get {
            return _setting.squadron.uppercased()
        }
    }
    
    var squadronForAPI: String {
        return _setting.squadron
    }
    
    var squadrons: [String] {
        get {
            return _setting.squadrons.map { $0.uppercased() }
        }
    }
    
    var description: String {
        return """
        SettingViewModel: {
            firstName: \(firstName)
            lastName: \(lastName)
            fullName: \(fullName)
            squadron: \(squadron)
            squadronForAPI: \(squadronForAPI)
            squadrons: \(squadrons)
        """
    }
}

extension SettingViewModel {
    
    convenience init(setting: SettingModel) {
        self.init(setting: setting, realm: try! Realm())
    }
}
