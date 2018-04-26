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
    
    var travelingDB = [NSManagedObject]()
    var UIimageArray = [UIImage]()
    var locationName = ["秋紅谷", "彩虹眷村", "柳川新風情"]
    var locationImage = ["lake", "rainbow", "river"]
    var locationDescription = ["靜謐的都市綠地空間，以自然步道和充滿魚群、烏龜和鳥類的大型生態池聞名。","鄰近嶺東科技大學，是條色彩繽紛、充滿童趣彩繪的巷道。","柳川水岸目前是親水兼具防洪效果的河岸分三區栽植楓香、黃花風鈴木、欒樹等植栽~打造出全年四季不同的河岸風貌。"]
    var colloectionGlobalView: UICollectionView?
    var isEmpty : Bool {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TravelingDB")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let count  = try context.count(for: request)
            return count == 0 ? true : false
        }catch{
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEmpty{
            for item in 0..<locationImage.count{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.insertNewObject(forEntityName: "TravelingDB", into: context) as! TravelingDB
                
                let byteData: Data = UIImagePNGRepresentation(UIImage(named: locationImage[item])!)!
                entity.locImg = byteData
                entity.locName = locationName[item]
                entity.locDesc = locationDescription[item]
                do{
                    try context.save()
                }catch{
                    print("Failed saving")
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TravelingDB")
        
        do{
            let results = try moc.fetch(fetchRequest)
            travelingDB = results as! [NSManagedObject]
        }catch{
            print("\(error)")
        }
        
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
        
        print(travelingDB[indexPath.row].value(forKey: "locName") as Any
)
        
        //cell.locationName.text = travelingDB[indexPath.row].value(forKey: "locName") as? String
        /*
         let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TravelingDB")
         
         do{
         let searchResult = try getContext().fetch(userFetch)
         
         for p in (searchResult as! [NSManagedObject]){
         let name =  p.value(forKey: "locName")
         let desc = p.value(forKey: "locDesc")
         let img = p.value(forKey: "locImg")
         let imageUIImage: UIImage = UIImage(data: img as! Data)!
         if(name as! String == locationName[indexPath.row]){
         print("name: \(name!), description: \(desc!)")
         
         cell.locationName.text = name as? String
         cell.locationImage.image = imageUIImage
         cell.locationDescription.text = desc as? String
         }
         }
         
         }catch{
         print("error")
         }
         */
        
        
        /*
         if UIimageArray.count != locationName.count {
         UIimageArray.append(UIImage(named: locationImage[indexPath.row])!)
         }*/
        return cell
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    /*
     override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated);
     self.navigationController?.setToolbarHidden(true, animated: animated)
     }*/
}
