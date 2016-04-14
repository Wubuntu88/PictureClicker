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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemDescription.text = String(format: "%@, $%d", item_name!, price!)
        if let image:UIImage = UIImage.init(named: item_location!){
            itemImage.image = image
        }
        
    }
    
    @IBAction func makePurchase(sender: UIButton) {
        
    }
    
    
}