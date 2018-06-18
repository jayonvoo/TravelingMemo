//
//  FavoritePage.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/6/14.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit

struct UserCollectionData {
    var parkName: String
    var time: String
}

class FavoritePage: UITableViewController{
    
    var dataCollection = [UserCollectionData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCollection.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionTable", for: indexPath)
        let parkTitle = cell.viewWithTag(1) as! UILabel
        let timeLabel = cell.viewWithTag(2) as! UILabel
        
        parkTitle.text = dataCollection[indexPath.row].parkName
        timeLabel.text = dataCollection[indexPath.row].time
        
        return cell
    }
}
