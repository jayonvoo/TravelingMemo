//
//  ViewController.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/4/17.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate {
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //隱藏頂上狀態列
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        performSegue(withIdentifier: "showPano", sender: nil)
        //print("clicked")
    }
}
