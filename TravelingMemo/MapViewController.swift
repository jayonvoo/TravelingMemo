//
//  MapViewController.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/4/20.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit
import GoogleMaps



class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 24.175750, longitude: 120.647807, zoom: 15)
        mapView.camera = camera
        mapView.mapType = .satellite
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 24.175750, longitude: 120.647807)
        marker.map = mapView
        marker.title = "住家"
        marker.snippet = "台灣"
        
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        performSegue(withIdentifier: "showPano", sender: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        marker.map = mapView
        marker.title = "經緯度"
        marker.snippet = "緯度: \(coordinate.latitude)\n經度: \(coordinate.longitude)"
        mapView.delegate = self
        
    }
    
    /*
     //隱藏頂上狀態列
     override var prefersStatusBarHidden: Bool {
     return true
     }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
