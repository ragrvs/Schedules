//
//  ChildController.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

/// Allows the user to edit the first name, last name, and current
/// selected squadron stored on disk.
class SettingChildController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameField: SubtitleTextField!
    @IBOutlet weak var lastNameField: SubtitleTextField!
    @IBOutlet weak var squadronField: SquadronPicker!
    
    /// Contains setting persisted on disk
    var setting: SettingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We must populate the settings first because we will the using the textfield to store
        // the current settings. Only after the user clicks save or cancel, we want to commit those
        // changes to the setting view model.
        populateSetting()
        initSquadronPicker()
    }
    
    private func populateSetting() {
        if let setting = setting {
            firstNameField.text = setting.firstName
            lastNameField.text = setting.lastName
            squadronField.text = setting.squadron
        }
    }
    
    private func initSquadronPicker() {
        squadronField.delegate = self
    }

    //  MARK: - Squadron Picker Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showSquadronPicker()
        return false
    }
    
    private func showSquadronPicker() {
        UIAlertController.showSquadronPicker(values: setting.squadrons, initialSelection: squadronField.text) { squadron in
            self.squadronField.text = squadron
        }
    }

    // MARK: - Persist State
    
    /// Persist state using `setting`
    func saveSetting() {
        if let setting = setting {
            setting.firstName = firstNameField.text!
            setting.lastName = lastNameField.text!
            setting.squadron = squadronField.text!
        }
    }
    
    // MARK: - Deinitialization
    
    /// Used to check retain cycles
    deinit {
        NSLog("\(self) deinitialized")
    }
}
