//
//  MakePurchaseViewController.swift
//  PictureClicker
//
//  Created by William Edward Gillespie on 4/13/16.
//  Copyright © 2016 William Edward Gillespie. All rights reserved.
//

import Foundation
import UIKit

class MakePurchaseViewController: UIViewController {
    var username:String?
    var db:PicDbWrapper?
    
    var item_name:String?
    var item_location:String?
    var price:Int?
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var makePurchaseButton: UIButton!
    @IBOutlet weak var userCreditsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemDescription.text = String(format: "%@, $%d", item_name!, price!)
        if let image:UIImage = UIImage.init(named: item_location!){
            itemImage.image = image
        }
        //do not allow the user to purchase if they already have it
        //or they do not have enough credits
        let userHasPicture:Bool = db!.userHasPicture(user: username!, picture_name: item_name!)
        let enoughCredits:Bool = db!.userHasEnoughCreditsForPicture(user: username!, picture_name: item_name!)
        if(userHasPicture || enoughCredits == false){
            makePurchaseButton.enabled = false
            makePurchaseButton.backgroundColor = UIColor.lightGrayColor()
        }
        let userCredits:Int = db!.creditsForUser(user: username!)
        userCreditsLabel.text =  String(format: "your\ncredits: %d", userCredits)
    }
    
    @IBAction func makePurchase(sender: UIButton) {
        db!.makePicturePurchaseForUser(user: username!, picture_name: item_name!)
        makePurchaseButton.enabled = false
        makePurchaseButton.backgroundColor = UIColor.lightGrayColor()
    }
    
    
}