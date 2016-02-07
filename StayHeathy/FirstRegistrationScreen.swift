//
//  FirstRegistrationScreen.swift
//  StayHeathy
//
//  Created by Roi Kedarya on 27/01/2016.
//  Copyright © 2016 Roi Kedarya. All rights reserved.
//

import UIKit

class FirstRegistrationScreen: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var smokingButton: UIButton!
    @IBOutlet weak var nonSmokingButton: UIButton!
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var userDetails:NSMutableDictionary!
    var textFieldPreviousText : NSString!
    var personDetails :NSDictionary!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("user_details") != nil) {
            self.personDetails = (userDefaults.objectForKey("user_details") as! NSDictionary)
            self.userDetails = NSMutableDictionary(dictionary: personDetails)
        } else {
            self.userDetails = NSMutableDictionary.init(capacity: 20)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("user_details") != nil) {
            self.personDetails = (userDefaults.objectForKey("user_details") as! NSDictionary)
            self.userDetails = NSMutableDictionary(dictionary: personDetails)
        }
        // update all fields from person
        self.updateAllFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.registerDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateAllFields() {
        if (self.userDetails.objectForKey("gender") != nil) {
            self.maleButton.selected = (self.userDetails.objectForKey("gender") as! NSString).isEqualToString("male")
            self.femaleButton.selected = !self.maleButton.selected
        }
        if (self.userDetails.objectForKey("age") != nil) {
            self.ageTextField.text = String(self.userDetails.objectForKey("age")!)
        }
        if (self.userDetails.objectForKey("city") != nil) {
            self.cityTextField.text = String(self.userDetails.objectForKey("city")!)
        }
        if (self.userDetails.objectForKey("is_smoking") != nil) {
            self.smokingButton.selected = (self.userDetails.objectForKey("is_smoking") as! NSString).boolValue
            self.nonSmokingButton.selected = !smokingButton.selected
        }
    }
    
    @IBAction func maleButtonTapped(sender: AnyObject) {
        self.femaleButton.selected = false
        self.maleButton.selected = true
        if (self.userDetails != nil) {
            self.userDetails.setObject("male", forKey: "gender")
        }
        
    }
    
    @IBAction func femaleButtonTapped(sender: AnyObject) {
        self.maleButton.selected = false
        self.femaleButton.selected = true
        if (self.userDetails != nil) {
            self.userDetails.setObject("female", forKey: "gender")
        }
        
    }
    
    @IBAction func smokeButtonTapped(sender: AnyObject) {
        self.smokingButton.selected = true
        self.nonSmokingButton.selected = false
        if (self.userDetails != nil) {
            self.userDetails.setObject("true", forKey: "is_smoking")
        }
    }
    
    @IBAction func nonSmokeButtonTapped(sender: AnyObject) {
        self.smokingButton.selected = false
        self.nonSmokingButton.selected = true
        if (self.userDetails != nil) {
            self.userDetails.setObject("false", forKey: "is_smoking")
        }
    }
    
    @IBAction func DoneButtonTapped(sender: AnyObject) {
        //self.registerDetails()
        
    }
    
    func registerDetails() {
        if (self.userDetails != nil) {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(self.userDetails, forKey: "user_details")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    // MARK: textField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // make sure the keyBoard dont go over the text field
        let textFieldDistanceToBottom = scrollView.frame.height - textField.frame.origin.y - textField.frame.height
        let distanceToKeyBoard = textFieldDistanceToBottom - 250
        if (distanceToKeyBoard < 0) {
            scrollView.setContentOffset(CGPointMake(0, abs(distanceToKeyBoard)+30), animated: true)
        }
        //clear the old text
        textFieldPreviousText = textField.text
        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        let textFieldTag = textField.tag
        switch (textFieldTag) {
        //age
        case 0:
            self.userDetails.setObject(ageTextField.text!, forKey: "age")
        //city
        case 1:
            self.userDetails.setObject(cityTextField.text!, forKey: "city")
        default:
            print("no uiTag found for TextField")
        }
        if (textField.text == "") {
            textField.text = textFieldPreviousText as String
        }
    }
    
}