//
//  ScheduleDataSource.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/13/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

// MARK: - Schedule Data Source

class EventDataSource: NSObject, UITableViewDataSource {
    
    var events: [EventViewModel] = []
    
    var emptyMessage: String
    
    private var _emptyEvent: EventViewModel {
        var event = EventModel()
        event.student = emptyMessage
        return EventViewModel(event: event)
    }
    
    init(emptyMessage: String = "Not data") {
        self.emptyMessage = emptyMessage
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.isEmpty ? 1 : events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as EventCell
        
        if events.isEmpty {
            cell.setup(with: _emptyEvent)
            tableView.separatorStyle = .none
        } else {
            cell.setup(with: events[indexPath.row])
            tableView.separatorStyle = .singleLine
        }
        
        return cell
    }
}
