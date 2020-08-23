//
//  EndedViewController.swift
//  Into The Void
//
//  Created by Yang on 3/22/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import Foundation
import UIKit
class EndedViewController: UIViewController {
    var gameViewController: GameViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func restartBtnOnClick(_ sender: Any) {
        gameViewController.scene.noteIndex = 0
        gameViewController.scene.restartScene()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func exitBtnOnClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        gameViewController.dismiss(animated: true, completion: nil)
    }
}
