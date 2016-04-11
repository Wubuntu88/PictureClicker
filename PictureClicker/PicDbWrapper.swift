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
    
    init(){
        db = createDatabase()
    }
    
    
    func createDatabase() -> FMDatabase? {
        let db:FMDatabase = FMDatabase(path: nil)
        if(db.open()){
            let createUserRelation = "create table user (username text primary key not null, password text, credits int);"
            let createPictureRelation = "create table picture(picture_id integer primary key autoincrement, picture_name text, file_name text);"
            
            if let success = try? db.executeUpdate("PRAGMA foreign_keys = YES", values: []) {
                print("success: \(success)")
            }
            //let createPictureOwningIntanceRelation = "create table picture_owning_instance(FOREIGN KEY(pic_id) REFERENCES picture(picture_id), FOREIGN KEY(picture_owner) REFERENCES user(username));"
            db.executeStatements(createUserRelation);
            db.executeStatements(createPictureRelation)
            //db.executeStatements(createPictureOwningIntanceRelation)
            db.executeStatements("create table author (author_id integer primary key, name text)")
            db.executeStatements("create table book (book_id integer primary key, author_id integer, title text, FOREIGN KEY(author_id) REFERENCES author(author_id))")            
            
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

