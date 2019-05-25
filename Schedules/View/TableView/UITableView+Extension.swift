//
//  UITableView+Extension.sw
//  Schedules
//
//  This class is merely for syntagic sugar for working
//  with table views and table view cells.
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

/// Merely syntatic sugar for registering and dequeing a
/// table view cell.
extension UITableView {
    
    /// Registers the given cell to this table view.
    func register<Cell: UITableViewCell>(_ : Cell.Type) where Cell: Reusable {
        register(Cell.nib, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
    /// Returns a reusable table view cell for the specified index path.
    func dequeueReusableCell<Cell: UITableViewCell>(
        forIndexPath indexPath: IndexPath) -> Cell where Cell: Reusable {
            
        guard let cell = dequeueReusableCell(
            withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
                fatalError("Could not deque cell")
        }
        
        return cell
    }
}


protocol Reusable {}

/// `Reusable` makes use of the class name to create
/// a reusable identifier and nib.
extension Reusable where Self: UITableViewCell {
    
    /// Returns the reuse identifier for the table view cell.
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    /// Returns the nib for the table view cell.
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
