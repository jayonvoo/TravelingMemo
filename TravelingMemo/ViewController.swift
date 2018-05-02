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
import SQLite3

class ViewController: UIViewController, GMSMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var UIimageArray = [UIImage]()
    var colloectionGlobalView: UICollectionView?
    var getDBImage: UIImage?
    var getModelData = [ModelTravelingClass]()
    let callDB = SQDBController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callDB.viewDidLoad()
        print(callDB.getDirectoryPath())
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getModelData = callDB.getAllValue()
        
        colloectionGlobalView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        colloectionGlobalView = collectionView
        return getModelData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.locationName.text = getModelData[indexPath.row].name
        cell.locationImage.image = callDB.getImage(getImagePath: getModelData[indexPath.row].img)
        cell.locationDescription.text = getModelData[indexPath.row].desc
        
        
        cell.layer.cornerRadius = 4.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
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
