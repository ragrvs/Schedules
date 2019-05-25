//
//  CustomTableViewCell.swift
//  Passwords
//
//  Created by Richard Zhunio on 5/9/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var instructorLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var squadronLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var briefLabel: UILabel!
    @IBOutlet weak var estimatedDepartureTimeLabel: UILabel!
    @IBOutlet weak var returnToBaseTimeLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var remarksLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup(with event: EventViewModel) {
        studentLabel.text = event.student
        instructorLabel.text = event.instructor
        typeLabel.text = event.type
        squadronLabel.text = event.squadron
        eventLabel.text = event.event
        briefLabel.text = event.brief
        estimatedDepartureTimeLabel.text = event.estimatedDepartureTime
        returnToBaseTimeLabel.text = event.returnToBaseTime
        hoursLabel.text = event.hours
        remarksLabel.text = event.remarks
        locationLabel.text = event.location
    }
}
