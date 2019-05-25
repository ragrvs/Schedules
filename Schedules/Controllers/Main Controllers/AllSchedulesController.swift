//
//  AllSchedulesController.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

/// Displays a date picker and the events for the specified date.
class AllSchedulesController: BaseScheduleViewController {
    
    /// Contains setting persisted on disk
    /// This is set by `SchedulesController`
    var setting: SettingViewModel? {
        didSet {
            updateTableView()
        }
    }
    
    /// Contains the current date
    var date: Date! {
        didSet {
            updateDatePicker()
        }
    }
    
    /// This is the `SchedulesController` that will be notified when
    /// date changes occur.
    var dateChangeDelegate: DateChangeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.date = date
        datePicker.datePickerDelegate = self
    }
}

// MARK: - Date Picker Delegate
extension AllSchedulesController: DatePickerDelegate {
    
    /// Triggered when the date changes in the `datePicker`
    func datePicker(didChangeDate date: Date) {
        dateChangeDelegate?.dateChange(shouldChangeDate: date)
    }
}

// MARK: - Update UI
extension AllSchedulesController {
    
    /// Updates the date picker
    func updateDatePicker() {
        if let datePicker = datePicker {
            datePicker.date = date
        }
    }
    
    /// Updates the table view
    func updateTableView() {
        if let tableView = tableView {
            tableView.reloadData()
        }
    }
}

// MARK: - Setting Segue
extension AllSchedulesController {
    
    /// Only perform segues when setting is set
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return setting != nil
    }
    
    /// Sets state on the destination view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SettingController {
            destination.setting = setting
        } else if let destination = segue.destination as? SearchController {
            destination.dataSource = dataSource
        }
    }
    
}
