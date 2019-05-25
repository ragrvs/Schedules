//
//  TextField.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

/// Represents a text field with custom insets dx and dy.
@IBDesignable class TextField: LeftTextField {
    
    typealias Inset = (dx: CGFloat, dy: CGFloat)
    
    var inset: Inset = Inset(dx: 10, dy: 10)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // Add padding
        let withPadding = bounds.insetBy(dx: inset.dx, dy: inset.dy)
        // Center text
        let centered = withPadding.offsetBy(dx: leftButtonSize.width / 2, dy: 0)
        
        return centered
    }
}

extension TextField {
    
    @IBInspectable var dx: CGFloat {
        set {
            inset.dx = dx
        }
        get {
            return inset.dx
        }
    }
    
    @IBInspectable var dy: CGFloat {
        set {
            inset.dy = dy
        }
        get {
            return inset.dy
        }
    }
}

extension UITextField {
    
    func transitionOrDimiss(to textFields: [UITextField]) -> Bool {
        
        if let index = textFields.firstIndex(of: self) {
            if index == textFields.count - 1 {
                resignFirstResponder()
            } else {
                textFields[index + 1].becomeFirstResponder()
            }
        }
        
        return false
    }
    
}
