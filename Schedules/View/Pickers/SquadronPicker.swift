//
//  File.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

/// Represents a dimple squadron picker
class SquadronPicker: SubtitleTextField {
    
    // Mark: - Model
    
    /// Represents the data that will be displayed on each row of the picker view
    var squadrons: [String] = []
    
    var currentSquadron: String {
        set {
            let caseInsensitiveCompare: (String) -> Bool =  { a in
                return a.equalTo(caseInsensitive: newValue)
            }
            
            if let row = squadrons.firstIndex(where: caseInsensitiveCompare) {
                picker.selectRow(row, inComponent: 0, animated: false)
                text = squadrons[row]
            }
        }
        get {
            let rowSelected = picker.selectedRow(inComponent: 0)
            return squadrons[rowSelected]
        }
    }
    
    // MARK: - Properties
    
    lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        
        picker.contentMode = .bottom
        picker.showsSelectionIndicator = true
        
        return picker
    }()
    
    lazy var toolBar: UIToolbar = {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        
        let toolBar = UIToolbar()
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        return toolBar
    }()
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initPicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initPicker()
    }
    
    func initPicker() {
        inputView = picker
        inputAccessoryView = toolBar
        
        picker.delegate = self
        picker.dataSource = self
    }
    
    // MARK: - Methods
    
    @objc func dismissPicker() {
        superview?.endEditing(true)
    }
    
    func reloadAllComponents() {
        picker.reloadAllComponents()
    }
}

extension SquadronPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return squadrons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return squadrons[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text = squadrons[row]
    }
}

extension String {
    func equalTo(caseInsensitive other: String) -> Bool {
        return self.caseInsensitiveCompare(other) == .orderedSame
    }
}
