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
        
        let db:FMDatabase = FMDatabase(path: "")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

