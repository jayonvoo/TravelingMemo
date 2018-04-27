//
//  ModelTravelingClass.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/4/26.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit

class ModelTravelingClass{
    
    var id: Int
    var longitude: Double
    var latitude: Double
    var name: String
    var desc: String
    var img: String
    
    init(id: Int, longitude: Double, latitude: Double, name: String, desc: String, img: String) {
        self.id = id
        self.name = name
        self.desc = desc
        self.img = img
        self.longitude = longitude
        self.latitude = latitude
    }
}
