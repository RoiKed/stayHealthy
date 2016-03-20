//
//  infoScreen.swift
//  StayHeathy
//
//  Created by Roi Kedarya on 06/02/2016.
//  Copyright © 2016 Roi Kedarya. All rights reserved.
//

import UIKit
import EventKit

class InfoScreen: UIViewController, UIPopoverPresentationControllerDelegate {
    
    
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
    
    func configureNavBar() {
        let navBar = self.navigationController?.navigationBar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: navBar!.frame.width, height: navBar!.frame.height))
        imageView.contentMode = .ScaleAspectFit
        let titleImage = UIImage(named: "topbartitle")
        let backgraundImage = UIImage(named: "topbarbg")
        imageView.image = titleImage
        navBar?.setBackgroundImage(backgraundImage, forBarMetrics: UIBarMetrics.Default)
        navigationItem.titleView = imageView
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let constraints = " WHERE id = '" + self.keyId + "'"
        dataToPresent = sqlCategory().allRows("name ASC", constraints: constraints)
        self.collectionRow = dataToPresent[0]
        self.titleLabel.text = self.verifyString(collectionRow.name)
        self.infoLabel.text =
            self.updateLabelWithLineSpacing(collectionRow.info1) +
            self.updateLabelWithLineSpacing(collectionRow.info2) +
            self.updateLabelWithLineSpacing(collectionRow.info3) +
            self.updateLabelWithLineSpacing(collectionRow.info4) +
            self.updateLabelWithLineSpacing(collectionRow.info5) +
            self.updateLabelWithLineSpacing(collectionRow.info6) +
            self.updateLabelWithLineSpacing(collectionRow.info7) +
            self.verifyString(collectionRow.info8)
        
        self.descriptionLabel.text = self.verifyString(collectionRow.note)
        let movieURLString = (collectionRow.movie as String)
        let movieString = "https://www.youtube.com/embed/" + self.getMovieIdFromStringUrl(movieURLString)
        self.webViewPlayer.allowsInlineMediaPlayback = true
        let embededString = "<iframe width=\"\(self.view.frame.width - 16)\" height=\"\(self.webViewPlayer.frame.height - 4)\" src=\"\(movieString)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>"
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
    
    func updateLabelWithLineSpacing(infoString:String) -> String {
        var upadtedText = self.verifyString(infoString)
        if (upadtedText != "") {
            upadtedText = upadtedText + "\n"
        }
        return upadtedText
    }
    
    func verifyString(string:String) -> String {
        var resultString = string
        if (resultString == "null") {
            resultString = ""
        }
        return resultString
    }
    
    
    
    @IBAction func reminderButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("CalenderPickerViewControllerSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CalenderPickerViewControllerSegue") {
            let nextVC = segue.destinationViewController as! CalenderPickerViewController
            nextVC.collectionRow = self.collectionRow
            //nextVC.view.frame = self.view.frame
            nextVC.preferredContentSize = self.backView.frame.size
            let popover = nextVC.popoverPresentationController
            if (popover != nil) {
                popover?.delegate = self
                popover?.sourceRect = CGRectMake(0,0,0,0)
            }
        }
    }
    
// @IBAction func popoverWithoutBarButton(sender: AnyObject?) {
//    
//    // grab the view controller we want to show
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"Pop"];
//    
//    // present the controller
//    // on iPad, this will be a Popover
//    // on iPhone, this will be an action sheet
//    controller.modalPresentationStyle = UIModalPresentationPopover;
//    [self presentViewController:controller animated:YES completion:nil];
//    
//    // configure the Popover presentation controller
//    UIPopoverPresentationController *popController = [controller popoverPresentationController];
//    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
//    popController.delegate = self;
//    
//    // in case we don't have a bar button as reference
//    popController.sourceView = self.view;
//    popController.sourceRect = CGRectMake(30, 50, 10, 10);
//    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
}
