//
//  HomePage.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/6/14.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


struct ParkingSpaceData{
    var areaId: String
    var areaName: String
    var parkName: String
    var totalSpace: Int
    var surplusSpace: String
    var payGuide: String
    var introduction: String
    var address: String
    var wgsX: Double
    var wgsY: Double
    var parkId: String
    
    init(dictionary: [String:Any]) {
        self.areaId = dictionary["areaId"] as? String ?? ""
        self.areaName = dictionary["areaName"] as? String ?? ""
        self.parkName = dictionary["parkName"] as? String ?? ""
        self.totalSpace = dictionary["totalSpace"] as? Int ?? 0
        self.surplusSpace = dictionary["surplusSpace"] as? String ?? ""
        self.payGuide = dictionary["payGuide"] as? String ?? ""
        self.introduction = dictionary["introduction"] as? String ?? ""
        self.address = dictionary["address"] as? String ?? ""
        self.wgsX = dictionary["wgsX"] as? Double ?? 0.0
        self.wgsY = dictionary["wgsY"] as? Double ?? 0.0
        self.parkId = dictionary["parkId"] as? String ?? ""
    }
}

class HomePage: UIViewController{
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var searchArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    var searchController: UISearchController!
    var searchTableList: SearchTableView!
    var jsonObject = [ParkingSpaceData]()
    var dispatch = DispatchSemaphore.init(value: 0)
    override func viewDidLoad() {
        
        
        dataInitializer()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.indoorPicker = false
        
        searchTableList = SearchTableView()
        
        searchController = searchControllerWith(searchResultsController: nil)
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        //addMarker()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error" + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!)
        let camera = GMSCameraPosition.camera(withLatitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        //let marker = GMSMarker(position: center)
        
        print("Latitude :- \(userLocation!.coordinate.latitude)")
        print("Longitude :-\(userLocation!.coordinate.longitude)")
        //marker.map = mapView
        //marker.title = "Current Location"
        locationManager.stopUpdatingLocation()
    }
    
    func searchControllerWith(searchResultsController: UIViewController?) -> UISearchController {
        
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "搜尋停車場"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        
        return searchController
    }
    
    func dataInitializer(){
        
        URLSession.shared.dataTask(with: URL(string: "https://data.tycg.gov.tw/opendata/datalist/datasetMeta/download?id=f4cc0b12-86ac-40f9-8745-885bddc18f79&rid=0daad6e6-0632-44f5-bd25-5e1de1e9146f")!){(data, responds, error) in
            
            if error == nil{
                
                do{
                    
                    if let json = try JSONSerialization.jsonObject(with: data!) as? [String:Any],
                        let arrayParse = json["parkingLots"] as? [[String:Any]]{
                        
                        for item in arrayParse{
                            
                            let dict = ParkingSpaceData(dictionary: item)
                            self.jsonObject.append(dict)
                            
                            //print(self.jsonObject[0].address)
                        }
                    }
                    
                    self.dispatch.signal()
                    
                }catch{}
            }
            
            }.resume()
        dispatch.wait()
    }
    
    func addMarker() {
        
        for item in 0..<jsonObject.count{
            let position = CLLocationCoordinate2D(latitude: jsonObject[item].wgsY, longitude: jsonObject[item].wgsX)
            let marker = GMSMarker(position: position)
            marker.title = jsonObject[item].parkName
            marker.map = mapView
        }
    }
}

extension HomePage: UISearchControllerDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTableList.tableView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let searchController = UISearchController(searchResultsController: searchTableList)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "搜尋停車場"
        searchTableList.carParkName = jsonObject.map({(parkingSpaceData: ParkingSpaceData) -> String in
            parkingSpaceData.parkName
        })
        searchTableList.passJsonObject = jsonObject
        searchTableList.getMapView = self.mapView
        self.present(searchController, animated: true, completion: nil)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchTableList.filterContent(searchString: searchBar.text!)
        
    }
    
    func didSelectParkName(_ name: String, _ latitude: Double, _ longitude: Double, _ passMapView: GMSMapView){
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
        self.mapView = passMapView
        self.mapView.camera = camera
        self.mapView.clear()
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.title = name
        marker.map = mapView
    }
}

extension HomePage: LocateOnTheMap{
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        let position = CLLocationCoordinate2DMake(lat, lon)
        let marker = GMSMarker(position: position)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
        self.mapView.camera = camera
        
        marker.title = "Address : \(title)"
        marker.map = self.mapView
        
    }
    
}

extension HomePage: GMSMapViewDelegate{
    
}
