//
//  ViewController.swift
//  PictureClicker
//
//  Created by William Edward Gillespie on 3/7/16.
//  Copyright © 2016 William Edward Gillespie. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func createDatabase() -> FMDatabase? {
        let db:FMDatabase = FMDatabase(path: nil)
        if(db.open()){
            let createUserRelation = "create table user (id text primary key not null, password text, credits int);"
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
        
        let insert = "insert into user(id, hashed_password, credits) values(?, ?, ?);"
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
    
    func testSelectFromUser(db:FMDatabase) {
        let select:String = "select * from user;";
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
    
    
    func createPrimitive() {
        let db:FMDatabase = FMDatabase(path: nil)
        let success:Bool = db.open()
        if success {
            let createStr:String = "create table bulktest1 (id integer primary key autoincrement, x text);"
            let insert1 = "insert into bulktest1 (x) values ('XXX');"
            let insert2 = "insert into bulktest1 (x) values ('YYY');"
            let insert3 = "insert into bulktest1 (x) values ('ZZZ');"
            let success2:Bool = db.executeStatements(createStr)
            db.executeStatements(insert1)
            db.executeStatements(insert2)
            db.executeStatements(insert3)
            if success2 {
                let select:String = "select count(*) as count from bulktest1;";
                let resultSet:FMResultSet? = try? db.executeQuery(select, values: [])
                while(resultSet != nil && resultSet!.next() == true){
                    if let x:Int32 = resultSet?.intForColumnIndex(0){
                        print("x: \(x)\n")
                    }
                    
                }
                
            }
        }
    }

}

