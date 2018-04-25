//
//  ComposeViewController.swift
//  TravelingMemo
//
//  Created by 創意遊玩 on 2018/4/21.
//  Copyright © 2018年 創意遊玩. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    weak var firstViewItemController: ViewController?
    var getUIImage: UIImage?
    var viewImageArray = [UIImage]()
    
    @IBOutlet weak var UINameText: UITextField!
    @IBOutlet weak var UIDescText: UITextView!
    
    
    @IBAction func UICameraBtn(_ sender: UIButton) {
        
        photoLibrary()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let destinationView: ViewController = segue.destination as! ViewController
     
     destinationView.locationName.append(UINameText.text!)
     destinationView.locationDescription.append(UIDescText.text)
     viewImageArray.append(getUIImage!)
     destinationView.UIimageArray = viewImageArray
     }*/
    
    func photoLibrary()
    {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.getUIImage = image
        }
        
        picker.dismiss(animated: true, completion: nil);
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
