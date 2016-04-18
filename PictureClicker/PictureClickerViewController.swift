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
    
    var timer:NSTimer?
    var countDownFrom = 9
    let startTime = 10
    
    var item_name:String?
    var item_location:String?
    
    @IBOutlet weak var userCreditsLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var countdownUntilNextClick: UILabel!
    
    @IBAction func tappedOnPicture(sender: UITapGestureRecognizer) {
        db?.incrementCreditsForUser(user: username!)
        itemImage.userInteractionEnabled = false
        countdownUntilNextClick.text = String(format: "%3d", startTime)
        let userCredits:Int = db!.creditsForUser(user: username!)
        userCreditsLabel.text =  String(format: "your\ncredits: %d", userCredits)
        timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    func countDown(){
        if countDownFrom > 0 {
            countdownUntilNextClick.text = String(format: "%3d", countDownFrom)
        }else{//if it hit zero
            timer?.invalidate()
            itemImage.userInteractionEnabled = true
            countdownUntilNextClick.text = "You may click"
            countDownFrom = 9
        }
        countDownFrom -= 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImage.userInteractionEnabled = true
        itemImage.image = UIImage(named: item_location!)
        let userCredits:Int = db!.creditsForUser(user: username!)
        userCreditsLabel.text =  String(format: "your\ncredits: %d", userCredits)
        itemDescription.text = item_name!
        countdownUntilNextClick.text = "You may click"
    }
}
















