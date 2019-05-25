//
//  DatePicker.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

/// Represents the delegate that will be notified of a date change.
protocol DatePickerDelegate {
    func datePicker(didChangeDate date: Date)
}

/// Represents a date picker.
class DatePicker: TextField {
    
    /// Delegate that will be notified of a date change.
    var datePickerDelegate: DatePickerDelegate?
    
    /// The current date in the date picker
    var date: Date = Date() {
        didSet {
            text = date.mondayJan102019()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        sharedInit()
    }
    
    /// Initializesa new date and sets the text field delegate
    /// to itself
    private func sharedInit() {
        date = Date()
        delegate = self
    }
}

extension DatePicker: UITextFieldDelegate {
    
    /// When the text field is selected we should show the date picker
    func textFieldShouldBeginEditing(_ dateField: UITextField) -> Bool {
        showDatePicker()
        return false
    }
    
    /// Shows the date picker and informs the date picker delegate
    /// which date was picked.
    private func showDatePicker() {
        UIAlertController.showDatePicker(date: date) { date in
            self.date = date
            self.datePickerDelegate?.datePicker(didChangeDate: date)
        }
    }
}
