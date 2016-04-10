//
//  UserLoginViewController.swift
//  PictureClicker
//
//  Created by William Edward Gillespie on 4/10/16.
//  Copyright © 2016 William Edward Gillespie. All rights reserved.
//

import Foundation
import UIKit


class UserLoginViewController: UIViewController {
    override func viewDidLoad() {
        print("hello world");
    }
    
    @IBAction func Login(sender: AnyObject) {
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    /*
     This method allows for the SingleStockView to unwind to this ViewController, which makes the transition fast.
     */
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    
  

}