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
    var username:String? = nil
    var db:PicDbWrapper = PicDbWrapper()
    override func viewDidLoad() {
        super.viewDidLoad()
        db.testAddUsers()
        db.addAllPictures()
        //db.insertPictureOwningInstance(pictureId: 5, username: "Will")
        db.testAddPictureOwningInstances()
        db.createStore()
        //testSelectFromUser(db!)
            
        //testAddPicture(db!)
        //testSelectFromPicture(db!)
        
    }
    
    //IBOutlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func Login(sender: AnyObject) {
        
    }
    
    @IBAction func verifyUser(sender: AnyObject) {
        let inputUsername:String? = usernameField.text
        let inputPassword:String? = passwordField.text
        if inputPassword != nil && inputPassword != nil {
            let isValid:Bool = db.isValidUsernameAndPassword(inputUsername!, password: inputPassword!)
            if isValid {
                self.username = inputUsername
                loginButton.enabled = true
                loginButton.alpha = 1.0
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoginToPicturesSegue" {
            if let destination = segue.destinationViewController as? UINavigationController{
                if let dest = destination.topViewController as? UserPicturesViewController{
                    print("top view was user pics")
                    dest.username = username
                    dest.db = db
                }
            }
        }
    }
    
    /*
     This method allows for the SingleStockView to unwind to this ViewController, which makes the transition fast.
     */
    @IBAction func unwindToUserLoginVC(segue: UIStoryboardSegue) {
    }

}