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
    
    var username:String? = nil
    let pictureNames:[String] = ["Pictures/probe.jpg", "Pictures/stalker.jpeg",  "Pictures/zealot.jpg", "Pictures/zerglingPikachu.jpg", "Pictures/ultralisk.png", "Pictures/thor.png", "Pictures/roach.png", "Pictures/piplup.png", "Pictures/marine.jpeg", "Pictures/marauder.jpg", "Pictures/jigglypuff.png", "Pictures/hellbat.png", "Pictures/zergling.png", "Pictures/hadoop.png", "Pictures/ghost.jpeg", "Pictures/eevee.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return pictureNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("genericCell")!
        if let image:UIImage = UIImage.init(named: pictureNames[indexPath.row]){
            cell.imageView?.image = image
        }
        
        return cell
    }
    
    
}