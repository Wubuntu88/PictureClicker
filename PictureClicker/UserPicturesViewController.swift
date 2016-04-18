//
//  UserPicturesViewController.swift
//  PictureClicker
//
//  Created by William Edward Gillespie on 4/10/16.
//  Copyright © 2016 William Edward Gillespie. All rights reserved.
//

import Foundation
import UIKit

class UserPicturesViewController: UITableViewController {
    
    var username:String?
    var db:PicDbWrapper?
    var pictureData:[(Int, String, String)]?//id, name, filename
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(db != nil && username != nil){
            if pictureData == nil {
                pictureData = db!.fetchPictureData(user: username!)
            }
            return pictureData!.count
        }else{
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("genericCell")!
        if let image:UIImage = UIImage.init(named: pictureData![indexPath.row].2){
            cell.imageView?.image = image
        }
        let name:String = pictureData![indexPath.row].1
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LibraryToStoreSegue" {
            if let dest = segue.destinationViewController as? StoreTableViewController{
                dest.username = username
                dest.db = db
            }
        }else if segue.identifier == "LibraryToClickSegue" {
            if let dest = segue.destinationViewController as? PictureClickerViewController {
                dest.username = username
                dest.db = db
                let selectedIndex:Int = self.tableView.indexPathForSelectedRow!.row
                dest.item_name = pictureData![selectedIndex].1
                dest.item_location = pictureData![selectedIndex].2
            }
        }
    }
    
    @IBAction func unwindToUserPicturesVC(segue: UIStoryboardSegue) {
        pictureData = db!.fetchPictureData(user: username!)
        self.tableView.reloadData()
    }
    
    
}











