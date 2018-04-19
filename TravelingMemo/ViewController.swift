//
//  ViewController.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/4/17.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    var locationName = ["秋紅谷", "彩虹眷村", "柳川新風情"]
    var locationImage = ["lake", "rainbow", "river"]
    var locationDescription = ["靜謐的都市綠地空間，以自然步道和充滿魚群、烏龜和鳥類的大型生態池聞名。","鄰近嶺東科技大學，是條色彩繽紛、充滿童趣彩繪的巷道。","柳川水岸目前是親水兼具防洪效果的河岸分三區栽植楓香、黃花風鈴木、欒樹等植栽~打造出全年四季不同的河岸風貌。"]
    
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        /*
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
         */
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return locationName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.locationName.text = locationName[indexPath.row]
        cell.locationImage.image = UIImage(named: locationImage[indexPath.row])
        cell.locationDescription.text = locationDescription[indexPath.row]
        
        return cell
    }
}
