//
//  Levels.swift
//  Into The Void
//
//  Created by Yang on 3/21/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import Foundation
class Levels {
    static let instance: Levels = Levels()
    var levels = [[Note]]()
    
    func setUpLevels(){
        let notes = Notes.instance
         let levelOne = [notes.C[3], notes.D[3], notes.E[3], notes.F[3], notes.G[3], notes.A[3], notes.B[3], notes.C[4]]
        
        let levelTwo = [notes.C[3], notes.Gs[3], notes.Fs[3], notes.F[3], notes.Ds[3], notes.A[3], notes.B[3], notes.C[4]]
        
        let levelThree = [notes.Cs[3], notes.Gs[3], notes.Fs[3], notes.F[3], notes.Ds[3], notes.As[3], notes.B[3], notes.C[4]]
        
        let levelFour = [notes.C[3], notes.Cs[3], notes.C[4], notes.F[3], notes.G[3], notes.A[3], notes.B[3], notes.C[4]]
        
        let levelFive = [notes.C[3], notes.Gs[3], notes.D[3], notes.As[3], notes.E[3], notes.Af[3], notes.B[3], notes.C[4]]
        
        levels.append(levelOne)
        levels.append(levelTwo)
        levels.append(levelThree)
        levels.append(levelFour)
        levels.append(levelFive)
        
    }
    private init(){
        setUpLevels()
    }
}
