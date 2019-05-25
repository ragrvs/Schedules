//
//  SchedulesController.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit
import UserNotifications

/// Displays the user a date picker, graph, and table view.
/// It displays the events for the given date and draws a
/// hours vs date graph.
class SchedulesController: BaseScheduleViewController {
    
    @IBOutlet weak var chartView: EventLineChart!
    
    /// Data source presented to the user
    var filteredDataSource = EventDataSource()
    
    /// The setting stored on disk
    var setting: SettingViewModel?
    
    /// We load the setting either from disk or the network
    /// and then adopt the `DatePickerDelegate` so we can
    /// get notified when the user changes the date in this
    /// controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerDelegate = self
        
        Store.shared.loadSetting { setting in
            self.initSetting(setting)
            
            self.subscribeToSquadron()
            self.downloadChartData()
            self.downloadEvents()
        }
    }
}

// MARK: - Init Setting
fileprivate extension SchedulesController {
    
    /// Initializes the `setting` and adopts the `SettingDelegate`,
    /// so we are notified when settings change.
    private func initSetting(_ model: SettingModel) {
        setting = SettingViewModel(setting: model)
        setting?.delegate = self
    }
    
}

// MARK: - Download Events
fileprivate extension SchedulesController {
    
    /// Downloads the chart data that will drive the `chartView`.
    private func downloadChartData() {
        guard let setting = setting else { return }
        
        Store.shared.downloadChartData(setting: setting, forLastDays: 7) { hoursPerDay in
            self.updateChartData(with: hoursPerDay)
        }
    }
    
    /// Updates the `chartView`
    private func updateChartData(with hoursPerDay: [HoursPerDay]) {
        self.chartView.updateChart(with: hoursPerDay)
    }
    
    /// Once the events are downloaded, we must set the data source &
    /// filtered data source (drives the UI), update the UI, and finally
    /// update the `AllSchedulesController`.
    private func downloadEvents() {
        guard let setting = setting else { return }
        
        Store.shared.downloadEvents(squadron: setting.squadronForAPI,
                                    date: datePicker.date.yyyyMMdd()) { events in                           
            self.setDataSource(with: events)
            self.setFilteredDataSource()
            self.updateTableView()
            self.updateAllSchedulesController()
        }
    }
    
    /// Converst the given `events` to view models, sorts them by
    /// brief time, and sets the `dataSource` of this controller.
    private func setDataSource(with events: [EventModel]) {
        dataSource.events = events
            .map    (EventViewModel.init)
            .sorted { eventOne, eventTwo in eventOne.brief < eventTwo.brief }
    }
    
    /// Filters the data source for a specific student or instructor
    /// using the current setting, sorts them by brief time.
    private func setFilteredDataSource() {
        filteredDataSource.events = dataSource.events
            .filter (withStudentOrInstructor: setting?.fullName ?? "")
            .sorted { eventOne, eventTwo in eventOne.brief < eventTwo.brief }
    }
    
    /// Sets the result the filteredDataSource to the data source of this
    /// controllerm and then updates the table view.
    private func updateTableView() {
        self.tableView.dataSource = filteredDataSource
        self.tableView.reloadData()
    }
    
    /// Updates the `allSchedulesController` with the latest data.
    /// We also adopt the `DateChangeDateDelegate`
    /// so we can get notified when the date changes in
    /// `AllScheduleController` as well.
    private func updateAllSchedulesController() {
        if let controller = allSchedulesController {
            controller.dateChangeDelegate   = self
            controller.date                 = datePicker.date
            controller.setting              = setting
            controller.dataSource           = dataSource
        }
    }
}

// MARK: - Date Picker Delegate
extension SchedulesController: DatePickerDelegate, DateChangeDelegate {
    
    /// Triggered when the date changes in the `datePicker`
    /// NOTE: This is triggered by the date picker of this controller
    func datePicker(didChangeDate date: Date) {
        downloadEvents()
    }
    
    /// Triggered when this controller should change its date
    /// NOTE: This is triggered by the date picker of the `AllScheduleController`
    func dateChange(shouldChangeDate date: Date) {
        datePicker.date = date
        downloadEvents()
    }
}

// MARK: - Setting Delegate Methods
extension SchedulesController: SettingDelegate {
    
    /// Setting delegate method triggered when the name changes
    func didNameChange(_ setting: SettingViewModel, oldValue: String, newValue: String) {
        setFilteredDataSource()
        downloadChartData()
        
        // No need to re-download the events since we only need to filter out
        // a new name
        updateTableView()
    }
    
    /// Setting delegate method triggered when the squadron changes
    func didSquadronChange(_ setting: SettingViewModel, oldValue: String, newValue: String) {
        downloadChartData()
        downloadEvents()
        
        Store.shared.unsubscribe(fromSquadron: oldValue)
        Store.shared.subscribe(toSquadron: newValue)
    }
}

// MARK: - Setting Segue
extension SchedulesController {
    
    /// We should only go to the `SettingController` once the settings are loaded
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return setting != nil
    }
    
    /// We must set the settings in the `SettingController`
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingController = segue.destination as? SettingController {
            settingController.setting = setting
        }
    }
}

// MARK: - Helper methos
fileprivate extension SchedulesController {
    
    /// Finds the `AllSchedulesController`
    var allSchedulesController: AllSchedulesController? {
        return (tabBarController?.viewControllers?[1] as? UINavigationController)?
            .topViewController as? AllSchedulesController
    }
    
    /// Subscribes to the current squadron selected in setting
    func subscribeToSquadron() {
        if let setting = setting {
            Store.shared.subscribe(toSquadron: setting.squadron)
        }
    }
    
    /// Unsubscribes from the current squadron selected in setting
    func unsubscribeFromSquadron() {
        if let setting = setting {
            Store.shared.subscribe(toSquadron: setting.squadron)
        }
    }
}

/// Determines a date change
protocol DateChangeDelegate {
    func dateChange(shouldChangeDate date: Date)
}
