//
//  View.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit
import ChameleonFramework

/// View with a top to botton gradient.
@IBDesignable class TopToBottonGradientView: UIView {
    
    @IBInspectable var topColor: UIColor = .darkBlue {
        didSet {
            backgroundColor = GradientColor(.topToBottom, frame: frame, colors: [topColor, bottonColor])
        }
    }
    
    @IBInspectable var bottonColor: UIColor = .lightBlue {
        didSet {
            backgroundColor = GradientColor(.topToBottom, frame: frame, colors: [topColor, bottonColor])
        }
    }
}

/// Extension is merely used for syntatic sugar when adding constraints.
extension UIView {
    
    /// Anchors the current view to the superview's left, top, and
    /// botton constraints with a given width
    func anchorTo(left: NSLayoutXAxisAnchor, top: NSLayoutYAxisAnchor,
                  bottom: NSLayoutYAxisAnchor, withWidth width: CGFloat) {
        
        let leftConstraint = leftAnchor.constraint(equalTo: left)
        leftConstraint.priority = .defaultHigh
        leftConstraint.isActive = true
        
        let topConstraint = topAnchor.constraint(equalTo: top)
        topConstraint.priority = .defaultHigh
        topConstraint.isActive = true
        
        let bottonConstraint = bottomAnchor.constraint(equalTo: bottom)
        bottonConstraint.priority = .defaultHigh
        bottonConstraint.isActive = true
        
        let widthConstraint = widthAnchor.constraint(equalToConstant: width)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
    }
    
    /// Anchors the current view to the superview's center postion with the given size
    func anchorTo(centerX: NSLayoutXAxisAnchor, centerY: NSLayoutYAxisAnchor,
                  withSize size: CGSize) {
        let centerXConstraint = centerXAnchor.constraint(equalTo: centerX)
        centerXConstraint.priority = .defaultHigh
        centerXConstraint.isActive = true
        
        let centerYConstraint = centerYAnchor.constraint(equalTo: centerY)
        centerYConstraint.priority = .defaultHigh
        centerYConstraint.isActive = true
        
        let widthConstraint = widthAnchor.constraint(equalToConstant: size.width)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        let heightConstraint = heightAnchor.constraint(equalToConstant: size.height)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }
    
    func anchorTo(fillView view: UIView, withPriority priority: UILayoutPriority = .defaultHigh) {
        let topConstraint = topAnchor.constraint(equalTo: view.topAnchor)
        topConstraint.priority = priority
        topConstraint.isActive = true
        
        let bottonConstraint = bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottonConstraint.priority = priority
        bottonConstraint.isActive = true
        
        let rightConstraint = rightAnchor.constraint(equalTo: view.rightAnchor)
        rightConstraint.priority = priority
        rightConstraint.isActive = true
        
        let leftConstraint = leftAnchor.constraint(equalTo: view.leftAnchor)
        leftConstraint.priority = priority
        leftConstraint.isActive = true
    }
}

extension UIView {
    
    /// Enables or disables auto layout
    var autoLayout: Bool {
        set {
            translatesAutoresizingMaskIntoConstraints = !newValue
        }
        get {
            return !translatesAutoresizingMaskIntoConstraints
        }
    }
}
