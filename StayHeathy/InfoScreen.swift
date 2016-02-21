//
//  infoScreen.swift
//  StayHeathy
//
//  Created by Roi Kedarya on 06/02/2016.
//  Copyright © 2016 Roi Kedarya. All rights reserved.
//

import UIKit
import EventKit

class InfoScreen: UIViewController {
    
    
    @IBOutlet var backView: UIView!
    @IBOutlet weak var webViewPlayer: UIWebView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    var keyId: String!
    var savedEventId : String = ""
    var dataToPresent = [sqlCategory]()
    var collectionRow : sqlCategory!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let constraints = " WHERE id = '" + self.keyId + "'"
        dataToPresent = sqlCategory().allRows("name ASC", constraints: constraints)
        self.collectionRow = dataToPresent[0]
        self.titleLabel.text = self.verifyString(collectionRow.name)
        self.infoLabel.text =
            self.verifyString(collectionRow.info1) + "\n" +
            self.verifyString(collectionRow.info2) + "\n" +
            self.verifyString(collectionRow.info3) + "\n" +
            self.verifyString(collectionRow.info4) + "\n" +
            self.verifyString(collectionRow.info5) + "\n" +
            self.verifyString(collectionRow.info6) + "\n" +
            self.verifyString(collectionRow.info7) + "\n" +
            self.verifyString(collectionRow.info8)
        
        self.descriptionLabel.text = self.verifyString(collectionRow.note)
        let movieURLString = (collectionRow.movie as String)
        let movieString = "https://www.youtube.com/embed/" + self.getMovieIdFromStringUrl(movieURLString)
        self.webViewPlayer.allowsInlineMediaPlayback = true
        let embededString = "<iframe width=\"\(self.webViewPlayer.frame.width - 16)\" height=\"\(self.webViewPlayer.frame.height - 4)\" src=\"\(movieString)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>"
        self.webViewPlayer.loadHTMLString(embededString, baseURL: nil)
    }
    
    func getMovieIdFromStringUrl(movieURLString:String) -> String {
        var movieId = ""
        if ((movieURLString.rangeOfString("?v=")) != nil) {
            let movieRange = movieURLString.rangeOfString("?v=")?.endIndex
            movieId = movieURLString.substringFromIndex(movieRange!)
        }
        return movieId
    }
    
    func verifyString(string:String) -> String {
        var resultString = string
        if (resultString == "null") {
            resultString = ""
        }
        return resultString
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CalenderPickerViewController") {
            let nextVC = segue.destinationViewController as! CalenderPickerViewController
            nextVC.collectionRow = self.collectionRow
        }
    }
    
    // Creates an event in the EKEventStore. The method assumes the eventStore is created and
    // accessible
//    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
//        let event = EKEvent(eventStore: eventStore)
//        
//        event.title = title
//        event.startDate = startDate
//        event.endDate = endDate
//        event.calendar = eventStore.defaultCalendarForNewEvents
//        do {
//            try eventStore.saveEvent(event, span: .ThisEvent)
//            
//            savedEventId = event.eventIdentifier
//        } catch {
//            print("Bad things happened")
//        }
//    }
//    
//    func calculateRemindersDates () {
//        let startDate = NSDate()
//        let frequency = collectionRow.frequency
//        let period = collectionRow.period
//        if (period == "Y") {
//        
//        }
//    }
//    
//    //
//    @IBAction func reminderButtonTapped(sender: AnyObject) {
//        let eventStore = EKEventStore()
//        
//        let startDate = NSDate()
//        let endDate = startDate.dateByAddingTimeInterval(60 * 60) // One hour
//        
//        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
//            eventStore.requestAccessToEntityType(.Event, completion: {
//                granted, error in
//                self.createEvent(eventStore, title: self.collectionRow.name, startDate: startDate, endDate: endDate)
//            })
//        } else {
//            createEvent(eventStore, title: self.collectionRow.name, startDate: startDate, endDate: endDate)
//        }
//    }
}
