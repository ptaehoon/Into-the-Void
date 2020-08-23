  
//
//  Note.swift
//  Test2
//
//  Created by Yang on 2/24/20.
//  Copyright © 2020 apple－pc. All rights reserved.
//
import Foundation
import UIKit
class Note: CustomStringConvertible  {
    //main name
    var name: String = ""
    //name of sharp
    var sharpName: String = ""
    //name of flat
    var flatName: String = ""
    //frequency and octave
    let freq: CGFloat
    let baseFreq: CGFloat
    //int
    let octave: Int
    let flatToSharp = ["C♯": "D♭",
                       "D♯":"E♭",
                       "F♯":"G♭",
                       "G♯":"A♭",
                       "A♯":"B♭"]
    let sharpToFlat = [ "D♭":"C♯",
                        "E♭":"D♯",
                        "G♭":"F♯",
                        "A♭":"G♯",
                        "B♭":"A♯"]
    
    init(name:String, baseFreq: Float, octave: Int) {
        self.octave = octave
        //self.freq = baseFreq * Float(octave + 1)
        self.baseFreq = CGFloat(baseFreq)
        self.freq = CGFloat(baseFreq * Float(truncating: NSDecimalNumber(decimal: pow(2, octave))))
        self.name = name
        if(name.contains("♯")){
            self.sharpName = name
            self.flatName = sharpToFlat[name] ?? "NONE";
        } else if(name.contains("♭")){
            self.flatName = name
            self.sharpName = flatToSharp[name] ?? "NONE";
        }
    }
    
    func addOctave() -> Note {
        return Note(name: self.name, baseFreq: Float(self.baseFreq), octave: self.octave+1)
    }
    
    func subTractOctave() -> Note {
        return Note(name: self.name, baseFreq: Float(self.baseFreq), octave: self.octave-1)
    }
    //"toString" function
    public var description: String {
        return "name: \(self.name)\(self.octave) frequency: \(self.freq)"
    }
    
}
//Singleton Class
class Notes {
    static let instance: Notes = Notes()
    let noteFrequencies:[Float] = [16.35, 17.32, 17.32, 18.35, 19.45, 19.45, 20.6, 21.83, 23.12, 23.12, 24.5, 25.96, 25.96, 27.5, 29.14, 29.14, 30.87]
    let noteNames = ["C", "C♯", "D♭", "D", "D♯", "E♭", "E", "F", "F♯", "G♭", "G", "G♯", "A♭", "A", "A♯", "B♭", "B"]
    var C: [Note] = []
    var Cs: [Note] = []
    var Df: [Note] = []
    var D: [Note] = []
    var Ds: [Note] = []
    var Ef: [Note] = []
    var E: [Note] = []
    var F: [Note] = []
    var Fs: [Note] = []
    var Gf: [Note] = []
    var G: [Note] = []
    var Gs: [Note] = []
    var Af: [Note] = []
    var A: [Note] = []
    var As: [Note] = []
    var Bf: [Note] = []
    var B:[Note] = []
    var notes: [Note] = []
    func setupNotes() {
//        let arrOfNotes:[[Note]] = [C, Cs, Df, D, Ds, Ef, E, F, Fs, Gf, G, Gs, Af, A, As, Bf, B]
//        for i in 0...8 {
//            for j in 0...(arrOfNotes.count-1) {
//                notes.append(arrOfNotes[j][i])
//            }
//        }
        for i in 0...8 {
            var j = 0;
            C.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j], octave: i))
            j += 1
            Cs.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1
            Df.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1
            D.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            Ds.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            Ef.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            E.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            F.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            Fs.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            Gf.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            G.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            Gs.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            Af.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            A.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            As.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            Bf.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
            j += 1;
            B.append(Note(name: noteNames[j], baseFreq: noteFrequencies[j],  octave: i))
        }
    }
    
    private init(){
        setupNotes()
    }
}
