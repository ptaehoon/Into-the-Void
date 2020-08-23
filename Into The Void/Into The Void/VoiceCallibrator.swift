//
//  VoiceCallibrator.swift
//  Into The Void
//
//  Created by Andy Rochat on 3/18/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import UIKit
import AudioKit

class VoiceCallibrator: UIViewController {

    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var runtimer : Timer?
    
    @IBOutlet weak var currentNote: UILabel!
    @IBOutlet weak var highNote: UILabel!
    var highNoteNum: Double = UserDefaults.standard.double(forKey: "highNoteStoredValue")
    @IBOutlet weak var lowNote: UILabel!
    var lowNoteNum: Double = UserDefaults.standard.double(forKey: "lowNoteStoredValue")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AKSettings.sampleRate = AudioKit.engine.inputNode.inputFormat(forBus: 0).sampleRate
        do {
            try AudioKit.stop()
        }
        catch {
            AKLog("AudioKit haven't started yet!")
        }
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        runtimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(0.3),
            target      : self,
            selector    : #selector(VoiceCallibrator.updateCurrentNote),
            userInfo    : nil,
            repeats     : true)
        highNote.text = "High Note: " + CurrentUser.instance.highestNote.name + String(CurrentUser.instance.highestNote.octave)
        lowNote.text = "Low Note: " + CurrentUser.instance.lowestNote.name + String(CurrentUser.instance.lowestNote.octave)
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
    
    @objc func updateCurrentNote(){
//        print("made it in loop" + String(tracker.frequency))
        if tracker.amplitude > 0.05 {
//            print("made it in if statement in loop")
            currentNote.text = "Current Note: "+String(Int(tracker.frequency))
        }
    }
    func stopTimer() {
      runtimer?.invalidate()
      runtimer = nil
    }
    
    @IBAction func SetHighNoteButton(_ sender: Any) {
        let tempFreq = tracker.frequency
        if tempFreq > lowNoteNum {
            highNoteNum = tempFreq
            let note: Note = CurrentUser.instance.setHighNote(freq: highNoteNum)
            highNote.text = "High Note: " + note.name + String(note.octave)
        }
        else {
            addAlert(alertMessage: "High note must be greater than low note")
        }
    }
    
    @IBAction func LowNoteSetter(_ sender: Any) {
    
        let tempFreq = tracker.frequency
        if tempFreq < highNoteNum || highNoteNum == 0.0 {
            lowNoteNum = tempFreq
            let note: Note = CurrentUser.instance.setLowNote(freq: lowNoteNum)
            lowNote.text = "Low Note: " + note.name + String(note.octave)
            
        }
        else {
            addAlert(alertMessage: "Low note must be lower than high note")
        }
        
    }
    
    @IBAction func resetButton(_ sender: Any) {
        highNoteNum = 0.0
        UserDefaults.standard.set(highNoteNum, forKey: "highNoteStoredValue")
        highNote.text = "High Note: not set"
        lowNoteNum = 0.0
        UserDefaults.standard.set(lowNoteNum, forKey: "lowNoteStoredValue")
        lowNote.text = "Low Note: not set"
        CurrentUser.instance.resetNotes()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func doneButton(_ sender: Any) {
        
        if (CurrentUser.instance.highestNote.octave > CurrentUser.instance.lowestNote.octave) {
            stopTimer()
            print("made it here")
            let inputNode = AudioKit.engine.inputNode
            inputNode.removeTap(onBus: 0)
            
            do {
                try AudioKit.stop()
            }
            catch {
                print("couldnt stop audiokit")
            }
            self.performSegue(withIdentifier: "segueToMainPage", sender: nil)
            UserDefaults.standard.set(lowNoteNum, forKey: "lowNoteStoredValue")
            UserDefaults.standard.set(highNoteNum, forKey: "highNoteStoredValue")
        }
        else {
            let errorMessage = "Please make the notes at least two octaves apart.  Currently, the high note is rounded to: \(CurrentUser.instance.highestNote.name) in the \(CurrentUser.instance.highestNote.octave) octave and the low note is at: \(CurrentUser.instance.lowestNote.name)  in the \(CurrentUser.instance.lowestNote.octave) octave"
            addAlert(alertMessage: errorMessage)
        }
    }
    
    func addAlert(alertMessage:String) {
        let alert = UIAlertController(title: alertMessage, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
