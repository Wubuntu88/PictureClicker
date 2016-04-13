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
    //let pictureNames:[String] = ["Pictures/probe.jpg", "Pictures/stalker.jpeg",  "Pictures/zealot.jpg", "Pictures/zerglingPikachu.jpg", "Pictures/ultralisk.png", "Pictures/thor.png", "Pictures/roach.png", "Pictures/piplup.png", "Pictures/marine.jpeg", "Pictures/marauder.jpg", "Pictures/jigglypuff.png", "Pictures/hellbat.png", "Pictures/zergling.png", "Pictures/hadoop.png", "Pictures/ghost.jpeg", "Pictures/eevee.png"]
    var pictureFiles:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(db != nil && username != nil){
            if pictureFiles == nil {
                pictureFiles = db!.fetchPictureNames(username!)
            }
            return pictureFiles!.count
        }else{
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("genericCell")!
        if let image:UIImage = UIImage.init(named: pictureFiles![indexPath.row]){
            cell.imageView?.image = image
        }
        return cell
    }
    
    
}