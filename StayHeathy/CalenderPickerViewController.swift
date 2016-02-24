//
//  CalenderPickerViewController.swift
//  StayHeathy
//
//  Created by Roi Kedarya on 20/02/2016.
//  Copyright © 2016 Roi Kedarya. All rights reserved.
//

import UIKit
import EventKit

class CalenderPickerViewController: UIViewController {
    
    @IBOutlet var backView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var savedEventId : String = ""
    var collectionRow : sqlCategory!
    var lastExameDate : NSDate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.addTarget(self, action: "updateDate:", forControlEvents: UIControlEvents.ValueChanged)
        self.lastExameDate = NSDate()
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateDate(sender : UIDatePicker) {
        self.lastExameDate = sender.date
    }
    
    @IBAction func setButtonTapped(sender: AnyObject) {
        let eventStore = EKEventStore()
        
        let startDate = self.lastExameDate
        let endDate = startDate.dateByAddingTimeInterval(60 * 60) // One hour
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(eventStore, title: self.collectionRow.name, startDate: startDate, endDate: endDate)
            })
        } else {
            createEvent(eventStore, title: self.collectionRow.name, startDate: startDate, endDate: endDate)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Creates an event in the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        let eventRole = self.getRecurrenceEventRole()
        event.recurrenceRules = eventRole
        do {
            try eventStore.saveEvent(event, span: .FutureEvents)
            savedEventId = event.eventIdentifier
        } catch {
            print("Bad things happened")
        }
    }
    
    func getRecurrenceEventRole() -> [EKRecurrenceRule]? {
        let period = collectionRow.period
        var frequncy = Int(collectionRow.frequncy as String!)
        if (frequncy == nil) {
            frequncy = 1
        }
        //var end = EKRecurrenceEnd.init(endDate: <#T##NSDate#>)
        var eventRole : EKRecurrenceRule!
        if (period.caseInsensitiveCompare("Y") == .OrderedSame) {
            eventRole = EKRecurrenceRule.init(recurrenceWithFrequency: EKRecurrenceFrequency.Yearly, interval: frequncy!, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        } else if (period.caseInsensitiveCompare("M") == .OrderedSame) {
            eventRole = EKRecurrenceRule.init(recurrenceWithFrequency: EKRecurrenceFrequency.Monthly, interval: frequncy!, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        }
        return [eventRole]
    }
}

