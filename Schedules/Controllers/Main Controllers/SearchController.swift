//
//  SearchController.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

/// Allows user to search for entries in the `dataSource`. The
/// `dataSource` is used as the data store object containing all the entries
/// while the `filteredDataSource` is used to contain only the entries matching
/// the search criteria.
class SearchController: NoTabBarController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    /// The data store containing all the entries
    var dataSource = EventDataSource()
    
    /// Contains the filtered entries from the `dataSource` matching the search criteria
    var filteredDataSource = EventDataSource(emptyMessage: "Please enter a search entry")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchBar()
        initTableView()
    }
    
    private func initSearchBar() {
        searchBar.delegate = self
        
        // This is not available in public API. If the text in the search bar is not black,
        // examine the following code
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .black
    }
    
    private func initTableView() {
        tableView.register(EventCell.self)
        
        // NOTE: The *** tableView.dataSource *** is the `filteredDataSource` (ALWAYS)
        tableView.dataSource = filteredDataSource
    }
    
    
    
    // MARK: Searching
    
    /// Searches for any entry in the `dataSource` containing the `searchText`.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredDataSource.events = dataSource.events.filter(withStudentOrInstructor: searchText)
        tableView.dataSource = filteredDataSource
        tableView.reloadData()
    }

    /// Dismisses keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    
    // MARK: - Deinitialization
    
    /// Used to check retain cycles
    deinit {
        NSLog("\(self) deinitialized")
    }
}
