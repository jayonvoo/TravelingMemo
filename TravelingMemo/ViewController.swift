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
    
    var UIimageArray = [UIImage]()
    var locationName = ["秋紅谷", "彩虹眷村", "柳川新風情"]
    var locationImage = ["lake", "rainbow", "river"]
    var locationDescription = ["靜謐的都市綠地空間，以自然步道和充滿魚群、烏龜和鳥類的大型生態池聞名。","鄰近嶺東科技大學，是條色彩繽紛、充滿童趣彩繪的巷道。","柳川水岸目前是親水兼具防洪效果的河岸分三區栽植楓香、黃花風鈴木、欒樹等植栽~打造出全年四季不同的河岸風貌。"]
    var colloectionGlobalView: UICollectionView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colloectionGlobalView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        colloectionGlobalView = collectionView
        return locationName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if UIimageArray.count != locationName.count {
            UIimageArray.append(UIImage(named: locationImage[indexPath.row])!)
        }
        
        cell.locationName.text = locationName[indexPath.row]
        cell.locationImage.image = UIimageArray[indexPath.row]
        cell.locationDescription.text = locationDescription[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController: ComposeViewController = segue.destination as! ComposeViewController
        
        DestViewController.viewImageArray = UIimageArray
    }
    
    /*
     override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated);
     self.navigationController?.setToolbarHidden(true, animated: animated)
     }*/
}
