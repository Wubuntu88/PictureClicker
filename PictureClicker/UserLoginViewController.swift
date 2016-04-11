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
    
    var username:String = ""
    var db:PicDbWrapper = PicDbWrapper()
    override func viewDidLoad() {
        super.viewDidLoad()
        db.testAddUsers()
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
                loginButton.enabled = true
                loginButton.alpha = 1.0
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoginToPicturesSegue" {
            if let destination = segue.destinationViewController as? UserPicturesViewController {
                destination.username = username
            }
        }
    }
    
    /*
     This method allows for the SingleStockView to unwind to this ViewController, which makes the transition fast.
     */
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    
    func createDatabase() -> FMDatabase? {
        let db:FMDatabase = FMDatabase(path: nil)
        if(db.open()){
            let createUserRelation = "create table user (username text primary key not null, password text, credits int);"
            let createPictureRelation = "create table picture(pic_id integer primary key autoincrement, pic_name text, file_name text);"
            db.executeStatements(createUserRelation);
            db.executeStatements(createPictureRelation)
            
            return db
        }
        return nil
    }
    /*
     CODE for adding users, and testing the adding of users and selecting them to see if it works
     */
    func addUser(userName:String, password:String, db:FMDatabase) -> Bool {
        
        let insert = "insert into user(username, password, credits) values(?, ?, ?);"
        let startingCredits = 20
        let values = [userName, password, startingCredits]
        do{
            try db.executeUpdate(insert, values: values as [AnyObject])
        }catch{
            print("execute failed");
            return false
        }
        return true
    }
    
    func testAddUsers(db:FMDatabase){
        addUser("Will", password: "12345", db: db)
        addUser("Cade", password: "54321", db: db)
        addUser("Wen", password: "01010", db: db)
        addUser("Andrew", password: "12345", db: db)
        addUser("Brenda", password: "54321", db: db)
        addUser("John", password: "01010", db: db)
        addUser("Chico", password: "01010", db: db)
    }
    
    func isValidUsernameAndPassword(db:FMDatabase, username: String, password: String) -> Bool {
        let select:String = "select * from user where username=\"\(username)\" and password=\(password);";
        let resultSet:FMResultSet? = try? db.executeQuery(select, values: [])
        if resultSet != nil && resultSet!.next() {
            print("hello")
            return true
        }
        return false
    }
    
    func testSelectFromUser(db:FMDatabase) {
        let select:String = "select * from user";
        let resultSet:FMResultSet? = try? db.executeQuery(select, values: [])
        while(resultSet != nil && resultSet!.next() == true){
            let name:String = resultSet!.stringForColumnIndex(0)
            let pswd:String = resultSet!.stringForColumnIndex(1)
            let credits:Int32 = resultSet!.intForColumnIndex(2)
            print("name: \(name), pswd: \(pswd), credits: \(credits)")
        }
    }
    
    /*
     Code for inserting records into the picture database, testing and selecting records to see if it works
     */
    func addPicture(pictureName:String, db:FMDatabase) -> Bool {
        let insert:String = "insert into picture(pic_name, file_name) values(?, ?)"
        let values = [pictureName, "\(pictureName).png"]
        
        do{
            try db.executeUpdate(insert, values: values)
        }catch{
            print("add picture failed");
            return false
        }
        return true
    }
    
    func testSelectFromPicture(db:FMDatabase) {
        let select:String = "select * from picture;";
        let resultSet:FMResultSet? = try? db.executeQuery(select, values: [])
        while(resultSet != nil && resultSet!.next() == true){
            let id:Int32 = resultSet!.intForColumnIndex(0)
            let name:String = resultSet!.stringForColumnIndex(1)
            let fileName:String = resultSet!.stringForColumnIndex(2)
            print("id: \(id), name: \(name), fileName: \(fileName)")
        }
    }
    
    func testAddPicture(db:FMDatabase) {
        addPicture("probe", db: db)
        addPicture("zergling", db: db)
        addPicture("hadoop", db: db)
        addPicture("Chico", db: db)
    }

}