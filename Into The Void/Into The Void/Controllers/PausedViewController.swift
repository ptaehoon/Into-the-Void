//
//  PulsedViewController.swift
//  Into The Void
//
//  Created by Yang on 3/22/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import Foundation
import UIKit
class PausedViewController: UIViewController {
    var gameViewController: GameViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func resumeClicked(_ sender: Any) {
        gameViewController.scene.isPaused = false
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func exitClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        gameViewController.dismiss(animated: true, completion: nil)
    }
}
