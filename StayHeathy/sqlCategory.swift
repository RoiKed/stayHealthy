//
//  sqlCategory.swift
//  StayHeathy
//
//  Created by Roi Kedarya on 05/02/2016.
//  Copyright © 2016 Roi Kedarya. All rights reserved.
//

import UIKit

class sqlCategory:SQLTable {
    var id = ""
    var name = ""
    var image = ""
    var movie = ""
    var period = ""
    var frequncy = ""
    var center = ""
    var headline = ""
    var explanation = ""
    var note = ""
    var info1 = ""
    var info2 = ""
    var info3 = ""
    var info4 = ""
    var info5 = ""
    var info6 = ""
    var info7 = ""
    var info8 = ""
    
    init() {
        super.init(tableName:"table1")
    }
    
    required convenience init(tableName:String) {
        self.init()
    }
}
