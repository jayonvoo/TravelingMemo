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
import Alamofire
import SwiftyJSON
import UserNotifications

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
    var myObject = GlobalModel()
    var locationManager = CLLocationManager()
    var searchArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    var searchController: UISearchController!
    var searchTableList: SearchTableView!
    var jsonObject = [ParkingSpaceData]()
    var dispatch = DispatchSemaphore.init(value: 0)
    var getCurrentLocation, getDestinationLocation: CLLocation!
    var minDistance: Double!
    var minDistancePath: CLLocation!
    var minDistParkName: String!
    var getMarkerPosition: CLLocationCoordinate2D?
    var passFavoriteData = FavoritePage()
    var getDidTapParkName, getDidTapTime: String!
    let window = InfoWindows.createInfoWindows()
    let timePicker = UIDatePicker()
    let toolbar = UIToolbar()
    let content = UNMutableNotificationContent()
    override func viewDidLoad() {
     
        ///System Notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        
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
        //let center = CLLocationCoordinate2D(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!)
        let camera = GMSCameraPosition.camera(withLatitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!, zoom: 15)
        
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        //let marker = GMSMarker(position: center)
        
        print("Latitude :- \(userLocation!.coordinate.latitude)")
        print("Longitude :-\(userLocation!.coordinate.longitude)")
        //marker.map = mapView
        //marker.title = "Current Location"
        locationManager.stopUpdatingLocation()
        
        getCurrentLocation = userLocation
        
        minDistance = getCurrentLocation.distance(from: CLLocation(latitude: jsonObject[0].wgsY, longitude: jsonObject[0].wgsX))
        minDistancePath = CLLocation(latitude: jsonObject[0].wgsY, longitude: jsonObject[0].wgsX)
        minDistParkName = jsonObject[0].parkName
        
        for location in jsonObject{
            
            let distance = CLLocation(latitude: location.wgsY, longitude: location.wgsX)
            
            if getCurrentLocation.distance(from: distance) < minDistance{
                minDistance = getCurrentLocation.distance(from: distance)
                minDistancePath = distance
                minDistParkName = location.parkName
            }
        }
        
        drawPath(currentLocation: getCurrentLocation, destinationLocation: minDistancePath)
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
    
    //路徑規劃
    func drawPath(currentLocation: CLLocation, destinationLocation: CLLocation){
        
        let origin = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
        let destination = "\(destinationLocation.coordinate.latitude),\(destinationLocation.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        let position = CLLocationCoordinate2D(latitude: destinationLocation.coordinate.latitude, longitude: destinationLocation.coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.title = minDistParkName
        marker.map = mapView
        self.mapView.delegate = self
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = try? JSON(data: response.data!)
            let routes = json!["routes"].arrayValue
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.geodesic = true
                polyline.strokeColor = UIColor.red
                polyline.map = self.mapView
            }
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        window.InfoTitle.text = marker.title
        getDidTapParkName = marker.title
        
        return window
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.mapView.selectedMarker = marker
        self.getMarkerPosition = marker.position
        window.directionBtn.addTarget(self, action: #selector(directionTap(sender:)), for: .touchUpInside)
        window.favoriteBtn.addTarget(self, action: #selector(favoriteBtn), for: .touchUpInside)
        
        window.center = mapView.projection.point(for: marker.position)
        window.center.y -= 20
        self.view.addSubview(window)
        return false
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if self.getMarkerPosition != nil{
            let location = self.getMarkerPosition
            window.center = mapView.projection.point(for: location!)
            window.center.y -= 20
        }
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        window.removeFromSuperview()
    }
    
    @objc func directionTap(sender: UIButton!){
        print("Direction Btn Tap!")
    }
    
    @objc func favoriteBtn(){
        
        timePicker.datePickerMode = .time
        timePicker.frame = CGRect(x: 0, y: self.view.frame.maxY - 245, width: self.view.bounds.width, height: 200)
        
        timePicker.backgroundColor = UIColor.white
        
        self.view.addSubview(timePicker)
        
        toolbar.barStyle = .default
        toolbar.isTranslucent = false
        toolbar.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        toolbar.sizeToFit()
        toolbar.frame.origin.y = timePicker.frame.minY - toolbar.frame.height
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(timePickFinish))
        
        toolbar.setItems([doneButton], animated: true)
        
        self.view.addSubview(toolbar)
        self.toolbar.isHidden = false
        self.timePicker.isHidden = false
    }
    
    @objc func timePickFinish(){
        
        let timeFormater = DateFormatter()
        timeFormater.timeStyle = .short
        getDidTapTime = timeFormater.string(from: timePicker.date)
        //passFavoriteData.dataCollection.append(UserCollectionData(parkName: getDidTapParkName, time: getDidTapTime))
        let favoTable = self.tabBarController?.viewControllers![1] as! FavoritePage
        favoTable.arrayObject.append(StoreGlobalModel(parkName: getDidTapParkName, time: getDidTapTime))
        
        favoTable.tableView.reloadData()
        
        myObject.parkName = "test01"
        myObject.time = "0:0"
        
        //passFavoriteData.tableView.reloadData()
        self.timePicker.isHidden = true
        self.toolbar.isHidden = true
    }
    
    
}

extension HomePage: UISearchControllerDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTableList.tableView.isHidden = true
    }
    
    ///當鍵入文字後，顯示搜尋結果
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
    
    ///篩選文字
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchTableList.filterContent(searchString: searchBar.text!)
        
    }
    
    ///選取和標記地圖
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
