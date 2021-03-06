//
//  FirstRegistrationScreen.swift
//  StayHeathy
//
//  Created by Roi Kedarya on 27/01/2016.
//  Copyright © 2016 Roi Kedarya. All rights reserved.
//

import UIKit

class SecondRegistrationScreen: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
        self.configureNavBar() 
    }
    
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

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("user_details") != nil) {
            self.personDetails = (userDefaults.objectForKey("user_details") as! NSDictionary)
            self.userDetails = NSMutableDictionary(dictionary: personDetails)
        }
        self.fullNameTextField.placeholder = "שם מלא"
        self.phoneNumberTextField.placeholder = "מספר טלפון"
        // update all fields for user details
        self.updateAllFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard () {
        self.fullNameTextField.resignFirstResponder()
        self.phoneNumberTextField.resignFirstResponder()
    }
    
    func updateAllFields() {
        if (self.userDetails.objectForKey("full_name") != nil) {
            self.fullNameTextField.text = String(self.userDetails.objectForKey("full_name")!)
        }
        if (self.userDetails.objectForKey("phone_number") != nil) {
            self.phoneNumberTextField.text = String(self.userDetails.objectForKey("phone_number")!)
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
                print("did not match medicalCenter with dictionary value")
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
        var canSegue = true
        let missingKey = self.checkMissingFields()
        //we have a missing key
        if (missingKey != nil) {
            canSegue = false
            let alert = UIAlertController(title: "", message: " אנא מלא את השדות הבאים: " + (missingKey as String!), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
        if canSegue {
            //segue to next screen
            self.registerDetails()
            self.performSegueWithIdentifier("segueToMenu", sender: nil)
        }
    }
    
    func registerDetails() {
        if (self.userDetails != nil) {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(self.userDetails, forKey: "user_details")
        }

        
    }
    
    func checkMissingFields() ->String? {
        var missingKey : String? = nil
        if (fullNameTextField.text == nil || fullNameTextField.text == "") {
            if (missingKey == nil) {
                missingKey = "שם-מלא"
            } else {
                missingKey! +=  ", שם-מלא"
            }
        }
        if (phoneNumberTextField.text == nil || phoneNumberTextField.text == "") {
            if (missingKey == nil) {
                missingKey = "מספר-טלפון"
            } else {
                missingKey! += ", מספר-טלפון"
            }
        }
        if (clalitButton.selected == false && leumitButton.selected == false && macabiButton.selected == false && meuhedetButton.selected == false) {
            if (missingKey == nil) {
                missingKey = "קופת-חולים"
            } else {
                missingKey! += ", קופת-חולים"
            }
        }
        return missingKey
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
        if (textField.tag == 3) {
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        //clear the old text
        if (textField.text != "") {
            textFieldPreviousText = textField.text!
        }
        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        if (textField.text == "" && textFieldPreviousText != nil) {
            textField.text = textFieldPreviousText as String
        } else {
            let textFieldTag = textField.tag
            switch (textFieldTag) {
            //full name
            case 2:
                self.userDetails .setValue(fullNameTextField.text!, forKey: "full_name")
            //phone number
            case 3:
                self.userDetails .setValue(phoneNumberTextField.text!, forKey: "phone_number")
            default:
                print("no uiTag found for TextField")
            }
        }
    }
    
}
