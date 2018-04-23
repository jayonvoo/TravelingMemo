//
//  ComposeViewController.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/4/21.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var UINameText: UITextField!
    @IBOutlet weak var UIDescText: UITextView!
    
    @IBAction func UICameraBtn(_ sender: UIButton) {
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationView: ViewController = segue.destination as! ViewController
        
        destinationView.locationName.append(UINameText.text!)
        destinationView.locationDescription.append(UIDescText.text)
        destinationView.locationImage.append("Nil")
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
