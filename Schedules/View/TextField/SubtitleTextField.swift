//
//  SubtitleTextField.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

/// Simple Textfield with a title and subtitle
@IBDesignable class SubtitleTextField: UITextField {
    
    // MARK: - Properties
    
    lazy var contentHorizontalInset: CGFloat = layoutMargins.left
    
    var titleLabel = UILabel()
    
    // MARK: - Methods
    
    override func draw(_ rect: CGRect) {
        addSubview(titleLabel)
        titleLabel.autoLayout = true
        
        heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 2.8).isActive = true
        
        layoutTitle()
    }
    
    // MARK: - Layout Title
    
    /// Sets up the constraints for the title
    /// When overriding this method, do not call super. Just set up the constraints for where
    /// you want the title to be. Assume auto layout is enabled
    func layoutTitle() {
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: contentHorizontalInset).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - Layout Subtitle (Text)
    
    /// Positions the text next to the left view and bellow the vertical center of the textfield.
    /// A default margin is added to the left
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: contentHorizontalInset, dy: bounds.midY)
    }
    
    // Does the same as text rect but when the text is being edited
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: contentHorizontalInset, dy: bounds.midY)
    }
}

// MARK: - IBInspectables

extension SubtitleTextField {
    
    @IBInspectable var title: String? {
        set {
            titleLabel.text = newValue
            titleLabel.font = font
        } get {
            return titleLabel.text
        }
    }
    
    @IBInspectable var horizontalInset: CGFloat {
        set {
            contentHorizontalInset = newValue
        }
        get {
            return contentHorizontalInset
        }
    }
    
    @IBInspectable var subtitle: String? {
        set {
            text = newValue
        }
        get {
            return text
        }
    }
    
    @IBInspectable var primaryColor: UIColor? {
        set {
            titleLabel.textColor = newValue
        }
        get {
            return titleLabel.textColor
        }
    }
    
    @IBInspectable var secondaryColor: UIColor? {
        set {
            textColor = newValue
        }
        get {
            return textColor
        }
    }

}


