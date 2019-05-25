//
//  SettingController.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//  Revision 1.0
//

import UIKit
import ChameleonFramework

/// Merely contains the UI and actions for the Settings controller.
/// For specific behavior, examine `SettingChildController`.
/// NOTE: It may seem overkill to have a embedded view, however,
/// table view is limited and this was the solution I found.
class SettingController: NoTabBarController, UITextFieldDelegate {
    
    /// Contains setting persisted on disk
    var setting: SettingViewModel!
    
    /// Reference to the embedded child controller
    var childController: SettingChildController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initBarButtonItems()
    }
    
    private func initBarButtonItems() {
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
        let save = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save(_:)))
        
        navigationItem.leftBarButtonItem = save
        navigationItem.rightBarButtonItem = cancel
    }
    
    // MARK: - Save & Cancel
    
    @objc func save(_ item: UIBarButtonItem) {
        saveSetting()
        
        // Now, returning the previous view controller...
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancel(_ item: UIBarButtonItem) {
        // We are not saving the changes
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Child Controller Transfer State
    
    /// Retrieves a refence to the `ChildController` and transfers state
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? SettingChildController {
            childController = destination
            childController.setting = setting
        }
    }
    
    /// Use the `childController` to save the changes. We use the `childController`
    /// because it is easier and it contains all the state onscreen.
    private func saveSetting() {
        if let childController = childController{
            childController.saveSetting()
        }
    }
    
    
    
    // MARK: - Deinitialization
    
    /// Used to check retain cycles
    deinit {
        NSLog("\(self) deinitialized")
    }
}
