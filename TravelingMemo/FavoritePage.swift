//
//  FavoritePage.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/6/14.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit

class FavoritePage: UITableViewController{
    
    var myObject = GlobalModel()
    var arrayObject = [StoreGlobalModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayObject.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionTable", for: indexPath)
        let parkTitle = cell.viewWithTag(1) as! UILabel
        let timeLabel = cell.viewWithTag(2) as! UILabel
        
        parkTitle.text = arrayObject[indexPath.row].parkName
        timeLabel.text = arrayObject[indexPath.row].time
        
        return cell
    }
}

