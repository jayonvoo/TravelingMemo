//
//  SQDBController.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/4/26.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit
import SQLite3

class SQDBController: UIViewController{
    
    var db: OpaquePointer?
    var returnStatement: OpaquePointer?
    
    
    let createTableQuery = "CREATE TABLE IF NOT EXISTS TravelingDB(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, longitude DOUBLE, latitude DOUBLE, desc TEXT, img TEXT)"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("TravelingDB.db")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
        }
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return
        }
        
        print("Database OK")
    }
    
    func insertTable(name: String, longitude: Double, latitude: Double, desc: String, img: String){
        
        
        let insertTableQuery = "INSERT INTO TravelingDB(name, longitude, latitude, desc, img)" +
        "values('\(name)', \(longitude), \(latitude), '\(desc)', '\(img)')"
        
        if sqlite3_prepare(db, insertTableQuery, -1, &returnStatement, nil) == SQLITE_OK{
            if sqlite3_step(returnStatement) == SQLITE_DONE{
                print("Insert Data Success")
            }
            
        }
        sqlite3_finalize(returnStatement)
    }
    
    func GetTestImageTable(){
        
        var sql = "select * from TravelingDB"
        
        if sqlite3_prepare(db, sql, -1, &returnStatement, nil) != SQLITE_OK{
            print("error")
        }
        
        while sqlite3_step(returnStatement) == SQLITE_ROW{
            let UI64bytes = String(cString: sqlite3_column_text(returnStatement, 5))
            
        }
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func saveImageDocumentDirectory(imageName: String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(imageName).jpg")
        let image = UIImage(named: imageName)
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
}
