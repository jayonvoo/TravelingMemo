//
//  PanoViewController.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/4/18.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit
import GoogleMaps

class PanoViewController: UIViewController {
    
    @IBOutlet weak var panoView: GMSPanoramaView!
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSPanoramaService().requestPanoramaNearCoordinate(CLLocationCoordinate2D(latitude: 24.175750, longitude: 120.647807)){pano, error in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            self.panoView.panorama = pano
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
