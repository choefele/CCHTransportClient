//
//  ViewController.swift
//  CCHTransportClient Example iOS
//
//  Created by Hoefele, Claus on 02.02.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let transportClient = CCHTransportDEBahnClient()
    var departures: [CCHTransportDeparture]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Departures Berlin-Friedrichstraße";
        self.transportClient.retrieveDeparturesForDate(nil, stationID: "0732531", maxNumberOfResults: 10) { [unowned self] departures, error in
            self.departures = departures as? [CCHTransportDeparture]
            self.tableView.reloadData()
        }
    }

}

extension ViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if let departure = departures?[indexPath.row] {
            cell.textLabel?.text = departure.service.name
            cell.detailTextLabel?.text = ViewController.stringForDate(departure.event.date)
        }

        return cell
    }
    
    private static func stringForDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        
        let theDateFormat = NSDateFormatterStyle.ShortStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.stringFromDate(date)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departures?.count ?? 0
    }
    
}

