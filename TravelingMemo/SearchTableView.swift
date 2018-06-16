//
//  SearchTableView.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/6/15.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit

protocol LocateOnTheMap{
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}

class SearchTableView: UITableViewController {
    
    var testStringArr = ["abc", "def", "ghi", "jkl", "lmn"]
    var searchResults: [String]!
    var filterArray = [String]()
    var getSearchBar: String!
    var delegate: LocateOnTheMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadDataWithArray(_ array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if getSearchBar != ""{
            return filterArray.count
        }else {
            return testStringArr.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        if getSearchBar != ""{
            cell.textLabel?.text = filterArray[indexPath.row]
        }else{
            cell.textLabel?.text = testStringArr[indexPath.row]
        }
        
        return cell
    }
    
    func filterContent(searchString: String){
        
        filterArray = testStringArr.filter(){nil != $0.range(of: searchString)}
        getSearchBar = searchString
        self.tableView.reloadData()
    }
    
}
