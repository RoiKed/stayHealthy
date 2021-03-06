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
    var textFieldPreviousText: NSString!
    var personDetails: NSDictionary!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("user_details") != nil) {
            self.personDetails = (userDefaults.objectForKey("user_details") as! NSDictionary)
            self.userDetails = NSMutableDictionary(dictionary: personDetails)
        } else {
            self.userDetails = ["gender":"","age":"","city":"","is_smoking":"","full_name":"","phone_number":"","medical_center":""]
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
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
    
    func dismissKeyboard () {
        cityTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.ageTextField.placeholder = "גיל"
        self.cityTextField.placeholder = "עיר"
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
            self.maleButton.selected = (self.userDetails.objectForKey("gender") as! NSString).caseInsensitiveCompare("M") == .OrderedSame
            self.femaleButton.selected = (self.userDetails.objectForKey("gender") as! NSString).caseInsensitiveCompare("F") == .OrderedSame
        }
        if (self.userDetails.objectForKey("age") != nil) {
            self.ageTextField.text = String(self.userDetails.objectForKey("age")!)
        }
        if (self.userDetails.objectForKey("city") != nil) {
            self.cityTextField.text = String(self.userDetails.objectForKey("city")!)
        }
        if (self.userDetails.objectForKey("is_smoking") != nil) {
            self.smokingButton.selected = (self.userDetails.objectForKey("is_smoking") as! NSString).boolValue
            self.nonSmokingButton.selected = (self.userDetails.objectForKey("is_smoking") as! NSString).boolValue
        }
    }
    
    @IBAction func maleButtonTapped(sender: AnyObject) {
        self.femaleButton.selected = false
        self.maleButton.selected = true
        if (self.userDetails != nil) {
            self.userDetails.setObject("M", forKey: "gender")
        }
        
    }
    
    @IBAction func femaleButtonTapped(sender: AnyObject) {
        self.maleButton.selected = false
        self.femaleButton.selected = true
        if (self.userDetails != nil) {
            self.userDetails.setObject("W", forKey: "gender")
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
//        for key in self.userDetails.allKeys {
//            if (self.userDetails.objectForKey(key) == nil ||  self.userDetails.objectForKey(key) as! NSString == "") {
//                canSegue = false
//                let alert = UIAlertController(title: "", message: " אנא מלא את השדות הבאים:" + (key as! String), preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
//                    alert.dismissViewControllerAnimated(true, completion: nil)
//                }))
//                presentViewController(alert, animated: true, completion: nil)
//            }
//        }
        if canSegue {
            //segue to next screen
            self.registerDetails()
            self.performSegueWithIdentifier("segueToSecondReg", sender: nil)
        }

    }
    
    func checkMissingFields() ->String? {
        var missingKey : String? = nil
        if (ageTextField.text == nil || ageTextField.text == "") {
            if (missingKey == nil) {
                missingKey = "גיל"
            } else {
                missingKey! += ", גיל"
            }
        }
        if (cityTextField.text == nil || cityTextField.text == "") {
            if (missingKey == nil) {
                missingKey = "עיר"
            } else {
                missingKey! += ", עיר"
            }
        }
        if (maleButton.selected == false && femaleButton.selected == false) {
            if (missingKey == nil) {
                missingKey = "מגדר"
            } else {
                missingKey! += ", מגדר"
            }
        }
        if (smokingButton.selected == false && nonSmokingButton.selected == false) {
            if (missingKey == nil) {
                missingKey = "מעשן"
            } else {
                missingKey! += ", מעשן"
            }
        }

        return missingKey
    }
    
    func registerDetails() {
        if (self.userDetails != nil) {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(self.userDetails, forKey: "user_details")
        }
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
        if (textField.tag == 0) {
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
            //age
            case 0:
                self.userDetails.setObject(ageTextField.text!, forKey: "age")
            //city
            case 1:
                self.userDetails.setObject(cityTextField.text!, forKey: "city")
            default:
                print("no uiTag found for TextField")
            }
        }
    }
    
}
