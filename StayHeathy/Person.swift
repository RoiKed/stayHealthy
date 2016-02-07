//
//  Person.swift
//  StayHeathy
//
//  Created by Roi Kedarya on 27/01/2016.
//  Copyright © 2016 Roi Kedarya. All rights reserved.
//

import Foundation

class Person:NSObject {
    var fullName : String?
    var email : String?
    var city : String?
    var medicalCenter : String?
    var age : Int?
    var isSmoking : Bool?
    var gender : String?
    
    override init() {
        super.init()
        self.fullName = ""
        self.email = ""
        self.city = ""
        self.medicalCenter = ""
        self.age = 0
        self.isSmoking = true
        self.gender = ""
    }
    init(userDetails:NSDictionary) {
        self.fullName = userDetails.objectForKey("") as? String
        self.email = userDetails.objectForKey("") as? String
        self.city = userDetails.objectForKey("") as? String
        self.medicalCenter = userDetails.objectForKey("") as? String
        self.age = Int((userDetails.objectForKey("") as? String)!)
        self.isSmoking = userDetails.objectForKey("")!.boolValue
        self.gender = userDetails.objectForKey("") as? String
    }
    
    private static var sharedInstance: Person?
    
    static func currentPerson() -> Person {
        if (sharedInstance == nil) {
           sharedInstance = Person()
        }
        return sharedInstance!
    }
}
