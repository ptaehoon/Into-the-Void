//
//  GameViewController.swift
//  Into The Void
//
//  Created by Andy Rochat on 2/9/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit
import GameplayKit

class GameViewController: UIViewController {
    //Audiokit objects
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    //SpriteKit objects
    var scene: GameScene!
    //rolling average to smooth player movement
    var BUFFERSIZE = 5;
    var rollingAverage: [CGFloat] = []
    //Current User (Singleton)
    var currentUser = CurrentUser.instance
    
    //Levels
    
    //GameMode: -1 is infinite randomly generated, otherwise it is levels index (levels[gameMode])
    var gameMode = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up microphone sampling. Frequency can be adjusted at timeInterval: x.x
        AKSettings.sampleRate = AudioKit.engine.inputNode.inputFormat(forBus: 0).sampleRate
        do {
            try AudioKit.stop()
        }
        catch {
            AKLog("AudioKit hasn't started yet!")
        }
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        Timer.scheduledTimer(timeInterval: 0.1,
                             target: self,
                             selector: #selector(GameViewController.updateUI),
                             userInfo: nil,
                             repeats: true)
    }
    //scene must be set up here to be able to constraint to the safe areas
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //set up scene
        scene = GameScene(size: view.bounds.size)
        //set the level
        if(gameMode != -1){
            scene.level = Levels.instance.levels[gameMode]
        }
        scene.gameMode = gameMode
        scene.gameViewController = self
        let skView = view as! SKView
        skView.presentScene(scene)
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
        if tracker.amplitude > 0.01 && !scene.isPaused && !scene.isDied && (CurrentUser.instance.insideNote == false || CurrentUser.instance.easyMode == false) {
            let freq = CGFloat(tracker.frequency)
            let newY = mapFreqToY(freq: freq,lowestNote: currentUser.lowestNote, highestNote: currentUser.highestNote)
            let average = calculateRollingAverage(newY: newY)

            scene.spaceShip.position = CGPoint(x: scene.spaceShip.position.x, y: average)
            
        }
        else {
            //if no sound detected, ship stays the same
            scene.spaceShip.position = CGPoint(x: scene.spaceShip.position.x, y: scene.spaceShip.position.y)
        }
    }
    
    func calculateRollingAverage(newY: CGFloat) -> CGFloat {
        rollingAverage.append(newY)
        if(rollingAverage.count > BUFFERSIZE) {
            rollingAverage.remove(at: 0)
        }
        let average = rollingAverage.reduce(0,+)/CGFloat(rollingAverage.count)
        return average
    }
    
    func mapFreqToY(freq: CGFloat, lowestNote: Note, highestNote: Note) -> CGFloat {
        //if the freq is out of range defined by user, map to the end points
        var freq = freq
        if freq < lowestNote.freq {
            freq = lowestNote.freq
        }
        if freq > highestNote.freq {
            freq = highestNote.freq
        }
        //this maps the frequency from [lowestFreq, highestFreq] to [bottom, top]
        //this counts for the pixels spaceship takes up
        let newY = (freq - lowestNote.freq) / (highestNote.freq - lowestNote.freq) * (view.bounds.size.height-100) + 50
        return newY
    }
    
    func alert(title:String = "ALERT", message: String){
        print("alert")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func displayPulseScreen(){
        let pausedVC = self.storyboard!.instantiateViewController(withIdentifier: "PausedVC") as! PausedViewController
        pausedVC.modalPresentationStyle = .popover
        pausedVC.gameViewController = self
        self.present(pausedVC, animated: true, completion: nil)
    }
    
    func displaySettingScreen(){
        let SettingsVC = self.storyboard!.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsController
        SettingsVC.modalPresentationStyle = .popover
        SettingsVC.gameViewController = self
        self.present(SettingsVC, animated: true, completion: nil)
    }
    
    func displayEndScreen(){
        let endedVC = self.storyboard!.instantiateViewController(withIdentifier: "EndedVC") as! EndedViewController
        endedVC.modalPresentationStyle = .popover
        endedVC.gameViewController = self
        self.present(endedVC, animated: true, completion: nil)
    }
    
    func displayDeadScreen(){
        let endedVC = self.storyboard!.instantiateViewController(withIdentifier: "DeadVC") as! DeadViewController
        endedVC.modalPresentationStyle = .popover
        endedVC.gameViewController = self
        self.present(endedVC, animated: true, completion: nil)
    }
    
}
