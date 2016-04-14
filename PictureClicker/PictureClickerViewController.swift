//
//  PictureClickerViewController.swift
//  PictureClicker
//
//  Created by William Edward Gillespie on 4/14/16.
//  Copyright © 2016 William Edward Gillespie. All rights reserved.
//

import Foundation
import UIKit

class PictureClickerViewController: UIViewController {
    var username:String?
    var db:PicDbWrapper?
    
    var item_name:String?
    var item_location:String?
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var countdownUntilNextClick: UILabel!
    
    @IBAction func tappedOnPicture(sender: UITapGestureRecognizer) {
        print("clicked \(item_name!)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImage.userInteractionEnabled = true
        itemImage.image = UIImage(named: item_location!)
        itemDescription.text = item_name!
    }
}
















