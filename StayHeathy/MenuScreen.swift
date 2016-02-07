//
//  SecondRegistrationScreen.swift
//  StayHeathy
//
//  Created by Roi Kedarya on 27/01/2016.
//  Copyright © 2016 Roi Kedarya. All rights reserved.
//

import UIKit

class MenuScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var personDetails :NSDictionary!
    //var dataToPresent = [sqlCategory]()
    //let db = SQLiteDB.sharedInstance()
    @IBOutlet weak var hartBtn: UIButton!
    @IBOutlet weak var generalBtn: UIButton!
    @IBOutlet weak var cancerBtn: UIButton!
    @IBOutlet weak var mouthBtn: UIButton!
    @IBOutlet weak var vacsinesBtn: UIButton!
    @IBOutlet weak var sqlDataCollection: UICollectionView!
    var rows:[SwiftData.SDRow] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("user_details") != nil) {
            self.personDetails = (userDefaults.objectForKey("user_details") as! NSDictionary)
        }
        let basicQuery = self.getBasicSqlQury()
        let (resultSet, err) = SwiftData.executeQuery(basicQuery)
        self.rows = resultSet
        
        if err != nil {
            //there was an error during the query, handle it here
        } else {
            for row in resultSet {
                if let name = row["Name"]?.asString() {
                    print("The Test name is: \(name)")
                }
            }
        }
        //dataToPresent = sqlCategory().allRows("name ASC", constraints: constraints)
        sqlDataCollection.reloadData()
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rows.count      //dataToPresent.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:SHViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CategoryCell", forIndexPath: indexPath) as! SHViewCell
        //let collectionRow = dataToPresent[indexPath.row]
        cell.title.text = self.rows
        let imageName = collectionRow.image
        cell.titleImage.image = UIImage(named: imageName);
        return cell
    }
    
    func getBasicSqlQury() -> String {
        let age = self.personDetails .objectForKey("age") as! String
        let basicConsteaints = "SELECT * FROM sheet1 WHERE start_age < " + age //+ " AND en__age > " + age
        return basicConsteaints
    }
    
    func getBasicSqlConstraints(addedConstraints:String)  {
        let fullSqlConsteaints = self.getBasicSqlQury() + addedConstraints
        //dataToPresent = sqlCategory().allRows("name ASC", constraints: fullSqlConsteaints)
        
        
        sqlDataCollection.reloadData()
    }
    
    @IBAction func hartButtonTapped(sender: UIButton) {
        let addedConstraints = " AND parent = hart"
        let fullSqlConsteaints = self.getBasicSqlQury() + addedConstraints
        
        self.sqlDataCollection.backgroundColor = UIColor.purpleColor()
    }
    
    @IBAction func vacsinsButtonTapped(sender: UIButton) {
        let addedConstraints = " AND parent = vacsine"
        self.getBasicSqlConstraints(addedConstraints)
        self.sqlDataCollection.backgroundColor = UIColor.yellowColor()
    }
    
    @IBAction func mouthButtonTapped(sender: UIButton) {
        let addedConstraints = " AND parent = mouth"
        self.getBasicSqlConstraints(addedConstraints)
        self.sqlDataCollection.backgroundColor = UIColor.redColor()
    }
    
    @IBAction func cancerButtonTapped(sender: UIButton) {
        let addedConstraints = " AND parent = cancer"
        self.getBasicSqlConstraints(addedConstraints)
        self.sqlDataCollection.backgroundColor = UIColor.orangeColor()
    }
    
    @IBAction func generalButtonTapped(sender: UIButton) {
        let addedConstraints = " AND parent = general"
        self.getBasicSqlConstraints(addedConstraints)
        self.sqlDataCollection.backgroundColor = UIColor.blueColor()
    }
    
}

