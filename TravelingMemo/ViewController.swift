//
//  ViewController.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/4/17.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData

class ViewController: UIViewController, GMSMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var restaurantDB:[TravelingDB] = []
    var UIimageArray = [UIImage]()
    var locationName = ["秋紅谷", "彩虹眷村", "柳川新風情"]
    var locationImage = ["lake", "rainbow", "river"]
    var locationDescription = ["靜謐的都市綠地空間，以自然步道和充滿魚群、烏龜和鳥類的大型生態池聞名。","鄰近嶺東科技大學，是條色彩繽紛、充滿童趣彩繪的巷道。","柳川水岸目前是親水兼具防洪效果的河岸分三區栽植楓香、黃花風鈴木、欒樹等植栽~打造出全年四季不同的河岸風貌。"]
    var colloectionGlobalView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in locationImage{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.insertNewObject(forEntityName: "TravelingDB", into: context) as! TravelingDB
            
            let byteData: Data = UIImagePNGRepresentation(UIImage(named: item)!)!
            entity.locImg = byteData
            
            do{
                try context.save()
            }catch{
                print("Failed saving")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TravelingDB")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "locImg") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
        
        if UIimageArray.count != locationName.count {
            UIimageArray.append(UIImage(named: locationImage[indexPath.row])!)
        }
        
        cell.locationName.text = locationName[indexPath.row]
        cell.locationImage.image = UIimageArray[indexPath.row]
        cell.locationDescription.text = locationDescription[indexPath.row]
        
        return cell
    }
    
    /*
     override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated);
     self.navigationController?.setToolbarHidden(true, animated: animated)
     }*/
}
