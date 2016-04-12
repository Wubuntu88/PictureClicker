//
//  PicDbWrapper.swift
//  PictureClicker
//
//  Created by William Edward Gillespie on 4/10/16.
//  Copyright © 2016 William Edward Gillespie. All rights reserved.
//

import Foundation

class PicDbWrapper{
    var db:FMDatabase?
    let pictureFolder:String = "Pictures/"
    
    init(){
        db = createDatabase()
    }
    
    
    func createDatabase() -> FMDatabase? {
        let db:FMDatabase = FMDatabase(path: nil)
        if(db.open()){
            let createUserRelation = "create table user(username text primary key not null, password text, credits int);"
            /* PICTURE*/
            let createPictureRelation = "create table picture(picture_id integer primary key autoincrement, picture_name text, file_name text);"
            
            if let success = try? db.executeUpdate("PRAGMA foreign_keys = YES", values: []) {
                print("success: \(success)")
            }
            let createPictureOwningIntanceRelation = "create table picture_owning_instance(pic_id integer, picture_owner text, FOREIGN KEY(pic_id) REFERENCES picture(picture_id), FOREIGN KEY(picture_owner) REFERENCES user(username));"
            let createPurchaseRelation = ["create table purchase(",
                        "pic_id integer, ",
                        "username text, ",
                        "date text,",
                        "FOREIGN KEY(pic_id) REFERENCES picture(picture_id)",
                        "FOREIGN KEY(username) REFERENCES user(username));"].reduce("", combine: +)
            let createStoreItemsRelation = ["create table store_items(",
                        "pic_id integer, ",
                        "price integer, ",
                        "FOREIGN KEY(pic_id) REFERENCES picture(picture_id));"].reduce("", combine: +)
            let createClickInstanceRelation = ["create table click_instance(",
                    "username text, ",
                    "pic_id integer, ",
                    "date text, ",
                    "FOREIGN KEY(username) REFERENCES user(username), ",
                    "FOREIGN KEY(pic_id) REFERENCES picture(picture_id));"].reduce("", combine: +)
            
            db.executeStatements(createUserRelation);
            db.executeStatements(createPictureRelation)
            db.executeStatements(createPictureOwningIntanceRelation)
            db.executeStatements(createPurchaseRelation)
            db.executeStatements(createStoreItemsRelation)
            db.executeStatements(createClickInstanceRelation)
            return db
        }
        return nil
    }
    /*
     CODE for adding users, and testing the adding of users and selecting them to see if it works
     */
    func addUser(userName:String, password:String) -> Bool {
        let insert = "insert into user(username, password, credits) values(?, ?, ?);"
        let startingCredits = 20
        let values = [userName, password, startingCredits]
        do{
            try db!.executeUpdate(insert, values: values as [AnyObject])
        }catch{
            print("execute failed");
            return false
        }
        return true
    }
    
    func testAddUsers(){
        addUser("Will", password: "12345")
        addUser("Cade", password: "54321")
        addUser("Wen", password: "01010")
        addUser("Andrew", password: "12345")
        addUser("Brenda", password: "54321")
        addUser("John", password: "01010")
        addUser("Chico", password: "01010")
    }
    
    func isValidUsernameAndPassword(username: String, password: String) -> Bool {
        let select:String = "select * from user where username=\"\(username)\" and password=\(password);";
        let resultSet:FMResultSet? = try? db!.executeQuery(select, values: [])
        if resultSet != nil && resultSet!.next() {
            return true
        }
        return false
    }
    
    func insertPictureOwningInstance(pictureId picId:Int, username:String){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
        let date = NSDate()
        let str = formatter.stringFromDate(date)
        print(str)
        let insert:String = "insert into picture_owning_instance(pic_id, picture_owner) values(?, ?)"
        let values = [picId, username]
        do{
            try db!.executeUpdate(insert, values: values as [AnyObject])
        }catch{
            print("execute failed");
        }
        
    }
    
    func testAddPictureOwningInstances(){
        //add for Will
        for index in 1..<5 {
            insertPictureOwningInstance(pictureId: index, username: "Will")
        }
    }
    /*
     * Adds a predifined list of picture names and file locations of pictures
     * to the database.
     */
    func addAllPictures(){
        let fileNames:[String] = ["eevee.png", "ghost.jpeg", "hadoop.png",
                                  "hellbat.png", "jigglypuff.png", "marauder.jpg",
                                  "marine.jpeg", "piplup.png", "probe.jpg",
                                  "roach.png", "stalker.jpeg", "thor.png",
                                  "ultralisk.png", "zealot.jpg", "zergling.png",
                                  "zerglingPikachu.jpg"]
        let names:[String] = fileNames.map({
            (fName:String) -> String in
            let str = fName.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))[0]
            return str
        })
        print(names)
        let insert = "insert into picture(picture_name, file_name) values(?, ?)"
        for index in 0..<fileNames.count {
            let values = [names[index], "\(pictureFolder)\(fileNames[index])"]
            do{
                try db!.executeUpdate(insert, values: values)
            }catch{
                print("add picture failed");
            }
        }
        let select:String = "select * from picture";
        let resultSet:FMResultSet? = try? db!.executeQuery(select, values: [])
        while(resultSet != nil && resultSet!.next() == true){
            //let name:String = resultSet!.stringForColumnIndex(0)
            let id:Int32 = resultSet!.intForColumnIndex(0)
            let name:String = resultSet!.stringForColumnIndex(1)
            let filename:String = resultSet!.stringForColumnIndex(2)
            print("id: \(id), name: \(name), filename: \(filename)")
        }
    }
    
    
    
    func testSelectFromUser() {
        let select:String = "select * from user";
        let resultSet:FMResultSet? = try? db!.executeQuery(select, values: [])
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
    func addPicture(pictureName:String) -> Bool {
        let insert:String = "insert into picture(picture_name, file_name) values(?, ?)"
        let values = [pictureName, "\(pictureName).png"]
        
        do{
            try db!.executeUpdate(insert, values: values)
        }catch{
            print("add picture failed");
            return false
        }
        return true
    }
    
    func testSelectFromPicture() {
        let select:String = "select * from picture;";
        let resultSet:FMResultSet? = try? db!.executeQuery(select, values: [])
        while(resultSet != nil && resultSet!.next() == true){
            let id:Int32 = resultSet!.intForColumnIndex(0)
            let name:String = resultSet!.stringForColumnIndex(1)
            let fileName:String = resultSet!.stringForColumnIndex(2)
            print("id: \(id), name: \(name), fileName: \(fileName)")
        }
    }
    
    func testAddPicture() {
        addPicture("probe")
        addPicture("zergling")
        addPicture("hadoop")
        addPicture("Chico")
    }
}

