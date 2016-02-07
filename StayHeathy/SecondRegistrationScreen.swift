//
//  FirstRegistrationScreen.swift
//  StayHeathy
//
//  Created by Roi Kedarya on 27/01/2016.
//  Copyright © 2016 Roi Kedarya. All rights reserved.
//

import UIKit

class SecondRegistrationScreen: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var macabiButton: UIButton!
    @IBOutlet weak var meuhedetButton: UIButton!
    @IBOutlet weak var leumitButton: UIButton!
    @IBOutlet weak var clalitButton: UIButton!
    
    var userDetails:NSMutableDictionary!
    var textFieldPreviousText : NSString!
    var personDetails :NSDictionary!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("user_details") != nil) {
            self.personDetails = (userDefaults.objectForKey("user_details") as! NSDictionary)
            self.userDetails = NSMutableDictionary(dictionary: personDetails)
        }
        // update all fields for user details
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
        if (self.userDetails.objectForKey("full_name") != nil) {
            self.fullNameTextField.text = String(self.userDetails.objectForKey("full_name")!)
        }
        if (self.userDetails.objectForKey("email") != nil) {
            self.emailTextField.text = String(self.userDetails.objectForKey("email")!)
        }
        if (self.userDetails.objectForKey("medical_center") != nil) {
            self.unselectAllMedicalCenterButtons()
            let medicalCenterSelected = (self.userDetails.objectForKey("medical_center") as! String)
            switch (medicalCenterSelected) {
            case "clalit":
                self.clalitButton.selected = true
            case "leumit":
                self.leumitButton.selected = true
            case "macabi":
                self.macabiButton.selected = true
            case "meuhedet":
                self.meuhedetButton.selected = true
            default:
                print("did not mtach medicalCenter with person's value")
                break
            }
        }
    }
    
    @IBAction func macabiButtonTapped(sender: AnyObject) {
        self.unselectAllMedicalCenterButtons()
        self.macabiButton.selected = true
        self.userDetails .setValue("macabi", forKey: "medical_center")
    }
    
    @IBAction func clalitButtonTapped(sender: AnyObject) {
        self.unselectAllMedicalCenterButtons()
        self.clalitButton.selected = true
        self.userDetails .setValue("clalit", forKey: "medical_center")
    }
    
    @IBAction func leumitButtonTapped(sender: AnyObject) {
        self.unselectAllMedicalCenterButtons()
        self.leumitButton.selected = true
        self.userDetails .setValue("leumit", forKey: "medical_center")
    }
    
    @IBAction func meuhedetButtonTapped(sender: AnyObject) {
        self.unselectAllMedicalCenterButtons()
        self.meuhedetButton.selected = true
        self.userDetails .setValue("meuhedet", forKey: "medical_center")
    }
    
    func unselectAllMedicalCenterButtons() {
        self.macabiButton.selected = false
        self.leumitButton.selected = false
        self.meuhedetButton.selected = false
        self.clalitButton.selected = false
    }
    
    @IBAction func DoneButtonTapped(sender: AnyObject) {
        self.registerDetails()
        
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
        textFieldPreviousText = textField.text!
        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        let textFieldTag = textField.tag
        switch (textFieldTag) {
        //full name
        case 2:
            self.userDetails .setValue(fullNameTextField.text!, forKey: "full_name")
        //email
        case 3:
            self.userDetails .setValue(emailTextField.text!, forKey: "email")
        default:
            print("no uiTag found for TextField")
        }
        if (textField.text == "") {
            textField.text = textFieldPreviousText! as String
        }
    }
    
}
