//
//  LeftTextField.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

/// Represents a text field with a left view
@IBDesignable class LeftTextField: UITextField, LeftView {
    
    // MARK: - Properties
    
    var leftViewSize: CGSize = CGSize(width: 50, height: Int.max)
    
    var leftButton = UIButton()
    
    var leftButtonSize: CGSize = CGSize(width: 30, height: 30)
    
    // Mark: - Draw
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        prepareToLayoutLeftView()
        style(view: layer)
    }
    
    func style(view: CALayer) {
        view.cornerRadius = 14
        view.shadowColor = UIColor.black.cgColor
        view.shadowOffset = CGSize(width: 1, height: 5)
        view.shadowRadius = 8
        view.shadowOpacity = 0.2
        view.shadowPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 14, height: 14)).cgPath
    }
    
    // MARK: Layout Left View
    
    func prepareToLayoutLeftView() {
        leftViewMode = .always
        leftView = UIView()
        layoutIfNeeded()
        
        leftButton.contentMode = .scaleAspectFit
        
        layoutLeftView()
    }
}

// MARK: - IBInspectables

extension LeftTextField {
    
    @IBInspectable var leftImage: UIImage? {
        set {
            leftButton.setImage(newValue, for: .normal)
            prepareToLayoutLeftView()
        }
        get {
            return leftButton.image(for: .normal)
        }
    }
    
}
