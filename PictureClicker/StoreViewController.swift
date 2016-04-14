//
//  StoreViewController.swift
//  PictureClicker
//
//  Created by William Edward Gillespie on 4/13/16.
//  Copyright © 2016 William Edward Gillespie. All rights reserved.
//

import Foundation
import UIKit

class StoreTableViewController: UITableViewController {
    
    @IBOutlet var storeTableView: UITableView!
    
    var username:String?
    var db:PicDbWrapper?
    var pictureData:[(Int, String, String)]?//id, name, filename
    var storeData:[(String, String, Int)]?//name, filename, price
    var item_names:[String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(db != nil && username != nil){
            if pictureData == nil {
                pictureData = db!.fetchPictureData(user: username!)
                storeData = db!.fetchStoreData()
            }
            return storeData!.count
        }else{
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("genericCell")!
        if let image:UIImage = UIImage.init(named: storeData![indexPath.row].1){
            cell.imageView?.image = image
        }
        let item_name = storeData![indexPath.row].0
        cell.textLabel?.text = item_name
        let price = storeData![indexPath.row].2
        cell.detailTextLabel?.text = "\(price)"
        
        var isOwnedByUser:Bool = false
        for tup in pictureData!{
            if tup.1 == item_name{
                isOwnedByUser = true
                break;
            }
        }
        cell.backgroundColor = isOwnedByUser ? UIColor.lightGrayColor() : UIColor.clearColor()
        return cell
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "itemCellToMakePurchaseSegue" {
            if let dest = segue.destinationViewController as? MakePurchaseViewController{
                if let indexPath = storeTableView.indexPathForSelectedRow {
                    dest.item_name = storeData![indexPath.row].0
                    dest.item_location = storeData![indexPath.row].1
                    dest.price = storeData![indexPath.row].2
                }
                dest.username = username
                dest.db = db
            }
        }
    }
}









