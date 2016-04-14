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
            let createUserRelation = ["create table user(",
                                      "username text primary key not null, ",
                                      "password text, ",
                                      "credits int);"].reduce("", combine: +)
            /* PICTURE*/
            let createPictureRelation = ["create table picture(",
                                         "picture_id integer primary key autoincrement, ",
                                         "picture_name text, ",
                                         "file_name text);"].reduce("", combine: +)
            
            if let success = try? db.executeUpdate("PRAGMA foreign_keys = YES", values: []) {
                print("success: \(success)")
            }
            let createPictureOwningIntanceRelation = ["create table picture_owning_instance(",
                        "pic_id integer, ",
                        "picture_owner text, ",
                        "FOREIGN KEY(pic_id) REFERENCES picture(picture_id), ",
                        "FOREIGN KEY(picture_owner) REFERENCES user(username));"].reduce("", combine: +)
            /*
            let createPurchaseRelation = ["create table purchase(",
                        "pic_id integer, ",
                        "username text, ",
                        "date text,",
                        "FOREIGN KEY(pic_id) REFERENCES picture(picture_id)",
                        "FOREIGN KEY(username) REFERENCES user(username));"].reduce("", combine: +)
             */
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
            //db.executeStatements(createPurchaseRelation)
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
        /*
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
        let date = NSDate()
        let str = formatter.stringFromDate(date)
        print(str)
        */
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
        //testSelectFromPicture()
    }
    
    /*
     * @return an array of tuples:[(Int, String, String)]
     * tup[0]: picture id
     * tup[1]: picture name
     * tup[2]: picture file name
     */
    func fetchPictureData(user username: String) -> [(Int, String, String)]?{
        var picFiles:[(Int, String, String)] = [(Int, String, String)]()
        let select:String = ["select picture_id, picture_name, file_name ",
                             "from picture, picture_owning_instance, user ",
                            "where username = \"\(username)\" AND ",
                            "picture_owner = username AND ",
                            "pic_id = picture_id"].reduce("", combine: +);
        if let resultSet:FMResultSet? = try? db!.executeQuery(select, values: []){
            while(resultSet != nil && resultSet!.next() == true){
                let pic_id:Int = Int(resultSet!.intForColumnIndex(0))
                let pic_name:String = resultSet!.stringForColumnIndex(1)
                let pic_file_name:String = resultSet!.stringForColumnIndex(2)
                let tup:(Int, String, String) = (pic_id, pic_name, pic_file_name)
                picFiles.append(tup)
            }
            return picFiles
        }
        return nil
    }
    
    func fetchStoreData() -> [(String, String, Int)]? {//picture name, file name, price
        var storeData:[(String, String, Int)] = [(String, String, Int)]()
        let select  = ["select picture_name, file_name, price ",
                        "from picture, store_items ",
                        "where picture_id = pic_id;"].reduce("", combine: +)
        if let resultSet:FMResultSet? = try? db!.executeQuery(select, values:[]){
            while(resultSet != nil && resultSet!.next() == true){
                let pic_name = resultSet!.stringForColumnIndex(0)
                let file_name = resultSet!.stringForColumnIndex(1)
                let price = Int(resultSet!.intForColumnIndex(2))
                let tup:(String, String, Int) = (pic_name, file_name, price)
                storeData.append(tup)
            }
            return storeData
        }
        return nil
    }
    
    func createStore(){
        let storeDict:Dictionary<String, Int> = ["eevee":2, "ghost":2, "hadoop":3,
                                  "hellbat":1, "jigglypuff":4, "marauder":2,
                                  "marine":1, "piplup":4, "probe":2,
                                  "roach":1, "stalker":3, "thor":3,
                                  "ultralisk":3, "zealot":1, "zergling":1,
                                  "zerglingPikachu":5]
        for (name, price) in storeDict {
            let success = addStoreItem(name, price: price)
            let message = success ? "\(name) successfully added to pictures table." : "could not add \(name) to pictures table."
            print(message)
        }
    }
    
    func addStoreItem(itemName: String, price: Int) -> Bool {
        let select = "select picture_id from picture where picture_name=\"\(itemName)\""
        let resultSet:FMResultSet? = try? db!.executeQuery(select, values: [])
        if resultSet != nil && resultSet!.next() == true {
            let pic_id:Int = Int(resultSet!.intForColumnIndex(0))
            let insert = "insert into store_items(pic_id, price) values(?, ?)"
            do{
                try db!.executeUpdate(insert, values: [pic_id, price])
                return true
            }catch{
                print("add store item failed");
                return false
            }
        }
        return false
    }
    
    func makePurchase(user user_name: String, item item_name:String){
        //TODO
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
}

