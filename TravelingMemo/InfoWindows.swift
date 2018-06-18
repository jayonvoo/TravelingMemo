//
//  InfoWindows.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/6/18.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit

class InfoWindows: UIView {
    
    @IBOutlet weak var InfoTitle: UILabel!
    @IBOutlet weak var directionBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    class func createInfoWindows() -> InfoWindows {
        let myClassNib = UINib(nibName: "InfoWindows", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! InfoWindows
    }
    
}

