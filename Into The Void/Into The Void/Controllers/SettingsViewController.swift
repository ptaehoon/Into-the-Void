//
//  SettingsViewController.swift
//  Into The Void
//
//  Created by Yang on 3/20/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class SettingsController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var gameViewController: GameViewController!
    @IBOutlet weak var sliderVal: UISlider!
    @IBOutlet weak var easyMode: UISwitch!
    
    @IBOutlet var currentPlayerAvatar: UIImageView!
    var customPlayerImage:SKSpriteNode?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderVal.value = CurrentUser.instance.baseSpeedGetter()
        
        easyMode.setOn(!UserDefaults.standard.bool(forKey: "easyMode"), animated: false)
        
        currentPlayerAvatar.image = mainInstance.img;
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        
//        CurrentUser.instance.easyMode = easyMode.isOn
        CurrentUser.instance.setEasyMode(easyModeTemp: easyMode.isOn)
        
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func baseSpeedSlider(_ sender: UISlider) {
        let currentValue = Double(sender.value)
        CurrentUser.instance.baseSpeedSetter(baseSpeedTemp: currentValue)
    }
    
    @IBAction func changePlayerAvatar(_ sender: Any) {
        accessPhotos();
    }
    
    // citation: https://www.zerotoappstore.com/how-to-access-camera-photo-library-in-swift.html (lines 52-62)
    func accessPhotos(){
          if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
              let imagePickerController = UIImagePickerController();
              imagePickerController.delegate = self;
              imagePickerController.sourceType = .photoLibrary;
              self.present(imagePickerController, animated:true,completion: nil);
          }
      }
      
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
              
      currentPlayerAvatar.image = image;
      
      mainInstance.img = image; // update global state
      
      let mytexture = SKTexture(image:image!);
      customPlayerImage = SKSpriteNode(texture:mytexture)
  
      mainInstance.currentPlayerImage = customPlayerImage ?? SKSpriteNode(imageNamed: "spaceship")

      self.dismiss(animated: true, completion: nil)
  }
    
}
