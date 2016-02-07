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
    
    init() {
        super.init(tableName:"tabel4")
    }
    
    required convenience init(tableName:String) {
        self.init()
    }
}
