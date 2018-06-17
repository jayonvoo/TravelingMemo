//
//  SearchTableView.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/6/15.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

struct LocationXY {
    var latitude: Double
    var longitude: Double
}

protocol LocateOnTheMap{
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}

class SearchTableView: UITableViewController {
    
    var carParkName: [String]!
    var locationData: [LocationXY]!
    var searchResults: [String]!
    var filterArray = [String]()
    var getSearchBar: String!
    var delegate: LocateOnTheMap!
    var homePageController = HomePage()
    var passJsonObject: [ParkingSpaceData]!
    var getMapView: GMSMapView!
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
            return carParkName.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        if getSearchBar != ""{
            cell.textLabel?.text = filterArray[indexPath.row]
        }else{
            cell.textLabel?.text = carParkName[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        homePageController.didSelectParkName(carParkName[indexPath.row], passJsonObject[indexPath.row].wgsY, passJsonObject[indexPath.row].wgsX, getMapView)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func filterContent(searchString: String){
        filterArray = carParkName.filter(){nil != $0.range(of: searchString)}
        getSearchBar = searchString
        self.tableView.reloadData()
    }
    
}
