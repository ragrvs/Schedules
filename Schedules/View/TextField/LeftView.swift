//
//  LeftView.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

/**
 Add this protocol to a view that you wish to contain a left view with an image inside.

 The simplest case consist in implementing `prepareToLayoutLeftView()` and then calling
 `layoutLeftView()` default's implementation.

 However, you must be careful to propertly initialized all the required properties and make sure
 the `leftView` is added to the view hierarchy before calling `layoutLeftView()`.

 The `leftView` is setup using autolayout. So, if you wish to override its constraints or
 properties, you can by setting new ones. The same appplies for the `leftImageView`.
 
 - Note: The `leftView` is added to the view hierarchy by calling `UIView.addSubview()`. However,
 in some weird cases it is not. So, you may need to call `setNeedsLayout` after adding the
 `leftView` to the view hierarchy and before calling `layoutLeftView()`.
 */
protocol LeftView {
    
    /**
     The left view of the view
 
     Must be initialized and added to the containing view
        ```
         leftView = UIView()
         addSubview(leftView)
        ```
     */
    var leftView: UIView? { set get }
    
    /// Size of the left view - only the width is uzed
    var leftViewSize: CGSize { set get }
    
    /**
     The left image view container for the image
 
     Must be initialized and contain an image as follows:
        ```
         leftImageView = UIImageView()
         leftImageView.image = myImage
        ```
     */
    var leftButton: UIButton { set get }
    
    /// Size of the buttom
    var leftButtonSize: CGSize { set get }
    
    /// Adds the `leftImageView` to the `leftView` and activates autolayout for both of them.
    func layoutLeftView()
}

extension LeftView where Self: UIView {
    
    /// Anchors the left view to the containing view's top, botton, and left constraints with a
    /// width of 55 points. The left image view is center in the left view with a width and height
    /// of 30 points.
    func layoutLeftView() {
        leftView?.addSubview(leftButton)
        leftView?.autoLayout = true
        leftView?.anchorTo(
            left: leftAnchor, top: topAnchor,
            bottom: bottomAnchor, withWidth: leftViewSize.width
        )
        
        leftButton.autoLayout = true
        leftButton.anchorTo(
            centerX: leftView!.centerXAnchor, centerY: leftView!.centerYAnchor,
            withSize: leftButtonSize)
        
        leftButton.imageView?.autoLayout = true
        leftButton.imageView?.anchorTo(fillView: leftButton)
    }
}
