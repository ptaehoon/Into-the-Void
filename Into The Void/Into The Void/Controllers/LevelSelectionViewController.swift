//
//  LevelSelectionViewController.swift
//  Into The Void
//
//  Created by Yang on 3/20/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import Foundation
import UIKit
class LevelSelectionViewController: UIViewController{
    //Outlets
    @IBOutlet weak var btnLevelOne: UIButton!
    @IBOutlet weak var btnLevelTwo: UIButton!
    @IBOutlet weak var btnLevelThree: UIButton!
    @IBOutlet weak var btnLevelFour: UIButton!
    @IBOutlet weak var btnLevelFive: UIButton!
    @IBOutlet weak var btnInfiniteChallenge: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToSettings(_ sender: Any) {
           let settingsVC = self.storyboard!.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsController
           settingsVC.modalPresentationStyle = .fullScreen
           self.present(settingsVC,animated:true, completion: nil)
    }
    
    @IBAction func levelOneOnClick(_ sender: Any) {
        let gameVC = self.storyboard!.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.gameMode = 0;
        self.present(gameVC, animated: true, completion: nil)
    }
    
    @IBAction func levelTwoOnClick(_ sender: Any) {
        print("levelTwoOnClick")
        let gameVC = self.storyboard!.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
               gameVC.modalPresentationStyle = .fullScreen
        gameVC.gameMode = 1;
        self.present(gameVC, animated: true, completion: nil)
    }
    @IBAction func levelThreeOnClick(_ sender: Any) {
        let gameVC = self.storyboard!.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
               gameVC.modalPresentationStyle = .fullScreen
        gameVC.gameMode = 2;
        self.present(gameVC, animated: true, completion: nil)
    }
    
    @IBAction func levelFourOnClick(_ sender: Any) {
        let gameVC = self.storyboard!.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
               gameVC.modalPresentationStyle = .fullScreen
        gameVC.gameMode = 3;
        self.present(gameVC, animated: true, completion: nil)
    }
    @IBAction func levelFiveOnClick(_ sender: Any) {
        let gameVC = self.storyboard!.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
               gameVC.modalPresentationStyle = .fullScreen
        gameVC.gameMode = 4;
        self.present(gameVC, animated: true, completion: nil)
    }
    @IBAction func infiniteOnClick(_ sender: Any) {
        let gameVC = self.storyboard!.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
               gameVC.modalPresentationStyle = .fullScreen
        gameVC.gameMode = -1;
        self.present(gameVC, animated: true, completion: nil)
    }

    @IBAction func backButtonOnClick(_ sender: Any) {
        print("here")
        self.dismiss(animated: true, completion: nil)
    }
}
