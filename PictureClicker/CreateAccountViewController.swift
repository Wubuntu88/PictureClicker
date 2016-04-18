//
//  CreateAccountViewController.swift
//  PictureClicker
//
//  Created by William Edward Gillespie on 4/17/16.
//  Copyright © 2016 William Edward Gillespie. All rights reserved.
//

import Foundation
import UIKit
class CreateAccountViewController: UIViewController {
    var db:PicDbWrapper?
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBAction func createAccount(sender: UIButton) {
        if usernameLabel.text != "" && passwordLabel.text != "" {
            let usernameExists = db!.existsUsername(usernameLabel.text!)
            if usernameExists {
                notificationLabel.text = "username is taken\ntry again!"
            }else{
                db!.addUser(usernameLabel.text!, password: passwordLabel.text!)
                notificationLabel.enabled = false
                notificationLabel.text = "Ready to go!\nwelcome \(usernameLabel.text!)"
                notificationLabel.alpha = 0.5
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}