//
//  SecondRegistrationScreen.swift
//  StayHeathy
//
//  Created by Roi Kedarya on 27/01/2016.
//  Copyright © 2016 Roi Kedarya. All rights reserved.
//

import UIKit

class MenuScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var personDetails: NSDictionary!
    var dataToPresent = [sqlCategory]()
    var selectedCellID: String!

    @IBOutlet weak var hartBtn: UIButton!
    @IBOutlet weak var generalBtn: UIButton!
    @IBOutlet weak var cancerBtn: UIButton!
    @IBOutlet weak var mouthBtn: UIButton!
    @IBOutlet weak var vacsinesBtn: UIButton!
    var lastConstraintsAdded: String?
    @IBOutlet weak var sqlDataCollection: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("user_details") != nil) {
            self.personDetails = (userDefaults.objectForKey("user_details") as! NSDictionary)
        }
        let constraints:String!
        if (self.lastConstraintsAdded == nil) {
            let addedConstraints = " AND parent = 'hart'"
            self.getBasicSqlConstraints(addedConstraints)
            //constraints = self.getBasicSqlConstraints()
        } else {
            constraints = self.lastConstraintsAdded
            dataToPresent = sqlCategory().allRows("name ASC", constraints: constraints)
            sqlDataCollection.reloadData()
        }
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let selectedCell:SHViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! SHViewCell
        self.selectedCellID = selectedCell.uniqueId
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "collectionSelectedSegue") {
            let nextVC = segue.destinationViewController as! InfoScreen
            nextVC.keyId = self.selectedCellID
        }
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToPresent.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:SHViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CategoryCell", forIndexPath: indexPath) as! SHViewCell
        let collectionRow = dataToPresent[indexPath.row]
        cell.title.text = collectionRow.name
        let imageName = collectionRow.image
        cell.uniqueId = collectionRow.id
        cell.titleImage.image = UIImage(named: imageName);
        return cell
    }
    
    func getBasicSqlConstraints() -> String {
        let age = self.personDetails .objectForKey("age") as! String
        let gender = self.personDetails .objectForKey("gender") as! String
        let basicConsteaints = " WHERE start_age < " + age + " AND end_age > " + age + " AND (sex = 'B' OR sex = '" + gender + "')"
        return basicConsteaints
    }
    
    func getBasicSqlConstraints(addedConstraints:String)  {
        let fullSqlConsteaints = self.getBasicSqlConstraints() + addedConstraints
        self.lastConstraintsAdded = fullSqlConsteaints
        dataToPresent = sqlCategory().allRows("name ASC", constraints: fullSqlConsteaints)
        //sqlDataCollection.performBatchUpdates(sqlDataCollection.reloadData(), completion:nil)
        sqlDataCollection.reloadData()
    }
    
    @IBAction func hartButtonTapped(sender: UIButton) {
        let addedConstraints = " AND parent = 'hart'"
        self.getBasicSqlConstraints(addedConstraints)
    }
    
    @IBAction func vacsinsButtonTapped(sender: UIButton) {
        let addedConstraints = " AND parent = 'vacsine'"
        self.getBasicSqlConstraints(addedConstraints)
    }
    
    @IBAction func mouthButtonTapped(sender: UIButton) {
        let addedConstraints = " AND parent = 'mouth'"
        self.getBasicSqlConstraints(addedConstraints)
    }
    
    @IBAction func cancerButtonTapped(sender: UIButton) {
        let addedConstraints = " AND parent = 'cancer'"
        self.getBasicSqlConstraints(addedConstraints)
    }
    
    @IBAction func generalButtonTapped(sender: UIButton) {
        let addedConstraints = " AND parent = 'general'"
        self.getBasicSqlConstraints(addedConstraints)
    }
    
}

