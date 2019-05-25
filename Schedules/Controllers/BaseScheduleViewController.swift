//
//  BaseScheduleViewController.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit
import EventKit
import Toast_Swift

///  Sets up a `tableView` and `datePicker` for subclasses to use.
///  NOTE: The `BaseScheduleViewController` merely contains boiler
///  plate code that may overcrowd other view controllers.
class BaseScheduleViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: DatePicker!
    
    /// Represents the data source that may drive the `tableview`
    var dataSource = EventDataSource()

    /// Initializes the date picker and table view
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    /// Initializes the table view
    private func initTableView() {
        tableView.register(EventCell.self)
        tableView.delegate = self
        tableView.dataSource = dataSource
    }
    
    
    /// Add event to calendar when each row is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the selected row
        tableView.deselectRow(at: indexPath, animated: false)
        
        let event = dataSource.events[indexPath.row]
        EKEventStore.addToCalendar(event: event, date: datePicker.date) { error in
            self.showToastMessage(error)
        }
    }
    
    /// Shows the appropiate toast message on the screen
    private func showToastMessage(_ error: Error?) {
        if error != nil {
            DispatchQueue.main.async {
                self.view.makeToast("Access to calendar denied", duration: 2.0)
            }
        } else {
            DispatchQueue.main.async {
                self.view.makeToast("Added event to calendar", duration: 2.0)
            }
        }
    }
}
