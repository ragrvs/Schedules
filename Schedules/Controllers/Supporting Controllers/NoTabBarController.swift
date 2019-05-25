//
//  NoTabBarController.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

/// Hides and shows the tab bar when this view controller appears
/// and disappears. It is useful when you need to push a new view
/// controller but you don't want the tab bar appearing on it.
class NoTabBarController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    private func hideTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        showTabBar()
    }
    
    private func showTabBar() {
        tabBarController?.tabBar.isHidden = false
    }
}
