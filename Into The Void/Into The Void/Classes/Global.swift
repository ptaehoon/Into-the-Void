//
//  Global.swift
//  Into The Void
//
//  Created by David Lie-Tjauw on 4/21/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import Foundation
import GameplayKit

class Main{
    var currentPlayerImage:SKSpriteNode
    var name = "testing"
    var img = UIImage(named: "spaceship")
    init(img:SKSpriteNode){
        self.currentPlayerImage = img
    }
    
}

var mainInstance = Main(img: SKSpriteNode(imageNamed: "spaceship"))


