//
//  CurrentUser.swift
//  Into The Void
//
//  Created by Yang on 3/21/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import Foundation
class CurrentUser {
    var lowestNote: Note = Notes.instance.C[3]
    var highestNote: Note = Notes.instance.C[4]
    var highestScore: Int = UserDefaults.standard.integer(forKey: "highScore")
    static let instance: CurrentUser = CurrentUser()
    var baseSpeed: Double = UserDefaults.standard.double(forKey: "baseSpeed")
    var insideNote = false
    var easyMode = true
    
    private init(){
        let highNoteNum: Double = UserDefaults.standard.double(forKey: "highNoteStoredValue")
        let lowNoteNum: Double = UserDefaults.standard.double(forKey: "lowNoteStoredValue")
        if highNoteNum != 0.0 {
            setHighNote(freq: highNoteNum)
        }
        if lowNoteNum != 0.0 {
            setLowNote(freq: lowNoteNum)
        }
        
        if baseSpeed == 0.0 {
            baseSpeed = 3
        }
    }
    func setHighScore(score:Int) {
        highestScore = score
        UserDefaults.standard.set(score, forKey: "highScore")
    }
    
    func resetNotes() {
        lowestNote = Notes.instance.C[3]
        highestNote = Notes.instance.C[4]
    }
    
    func setLowNote(freq: Double) -> Note{
        let (_, above) = getNoteBorders(freq: freq)
        lowestNote = above.0
//        UserDefaults.standard.set(lowestNote, forKey: "lowNote")
        return lowestNote
    }
    func setHighNote(freq: Double) -> Note{
        let (below, _) = getNoteBorders(freq: freq)
        highestNote = below.0
//        UserDefaults.standard.set(highestNote, forKey: "highNote")
        return highestNote
    }
    
    func getNoteBorders(freq: Double) -> ((Note, Double),(Note, Double)) {
        var closestNoteBelow:(Note, Double) = (Notes.instance.C[0], 0.0)
        var closestNoteAbove:(Note, Double) = (Notes.instance.B[8], 8000.00)
        
        func runNotes(tempNote: [Note]) {
            for i in tempNote {
                let newDist = abs(Double(i.freq)-freq)
                if (newDist < abs(freq-closestNoteBelow.1)) && (Double(i.freq) < freq) {
                    closestNoteBelow = (i, Double(i.freq))
                }
                else if (newDist < abs(freq-closestNoteAbove.1)) && (Double(i.freq) > freq) {
                    closestNoteAbove = (i, Double(i.freq))
                }
                print(i)
            }
        }
        runNotes(tempNote: Notes.instance.C)
        runNotes(tempNote: Notes.instance.Cs)
        runNotes(tempNote: Notes.instance.Df)
        runNotes(tempNote: Notes.instance.D)
        runNotes(tempNote: Notes.instance.Ds)
        runNotes(tempNote: Notes.instance.Ef)
        runNotes(tempNote: Notes.instance.E)
        runNotes(tempNote: Notes.instance.F)
        runNotes(tempNote: Notes.instance.Fs)
        runNotes(tempNote: Notes.instance.Gf)
        runNotes(tempNote: Notes.instance.G)
        runNotes(tempNote: Notes.instance.Gs)
        runNotes(tempNote: Notes.instance.Af)
        runNotes(tempNote: Notes.instance.A)
        runNotes(tempNote: Notes.instance.As)
        runNotes(tempNote: Notes.instance.Bf)
        runNotes(tempNote: Notes.instance.B)

        print(closestNoteAbove)
        print(closestNoteBelow)
        return (closestNoteBelow,closestNoteAbove)
        
    }
    
    func baseSpeedSetter(baseSpeedTemp: Double) {
        baseSpeed = baseSpeedTemp
        UserDefaults.standard.set(baseSpeedTemp, forKey: "baseSpeed")
    }
    
    func baseSpeedGetter() -> Float {
        var speed: Float = Float(UserDefaults.standard.double(forKey: "baseSpeed"))
        print(speed)
        if speed == 0.0 {
            speed = 3.0
        }
        print(speed)
        return speed
    }
    
    func setEasyMode(easyModeTemp: Bool) {
        easyMode = easyModeTemp
        UserDefaults.standard.set(!easyModeTemp, forKey: "easyMode")
    }
}
