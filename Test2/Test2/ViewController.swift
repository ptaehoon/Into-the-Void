//
//  ViewController.swift
//  Test2
//
//  Created by Yang on 2/15/20.
//  Copyright © 2020 apple－pc. All rights reserved.
//

import UIKit
import AudioKit
import SpriteKit
class ViewController: UIViewController{

    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var scene: GameScene!
    var notes: Notes = Notes.instance
    @IBOutlet weak var freqLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AKSettings.sampleRate = AudioKit.engine.inputNode.inputFormat(forBus: 0).sampleRate
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        Timer.scheduledTimer(timeInterval: 0.1,
        target: self,
        selector: #selector(ViewController.updateUI),
        userInfo: nil,
        repeats: true)
        //set up scene
        scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.presentScene(scene)
        //debug all the set up notes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        AudioKit.output = silence
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
    }
    
    @objc func updateUI(){
        if tracker.amplitude > 0 {
            let freq = String(format: "%.2f",tracker.frequency)
            freqLabel.text = "Frequency: \(freq) Hz"
            let newX = scene.player.position.x
            let newY = CGFloat(tracker.frequency*1.5)
            scene.player.position = CGPoint(x: newX, y: newY)
        }
    }
    
}

