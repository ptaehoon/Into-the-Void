//
//  GameElements.swift
//  Into The Void
//
//  Created by Taehoon Bang on 2/29/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import Foundation
import SpriteKit

struct CollisionBitMask {
    /*
     In the struct above, you have assigned categories to the physics bodies you will create later on in the game. Every physics body in a scene can be assigned to up to 32 different categories, each corresponding to a bit within the bit mask. With these categories assigned, you will later on define which physics bodies interact with each other and when your game is notified of these interactions.
     */
    static let spaceshipCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let groundCategory:UInt32 = 0x1 << 2
    static let centerNodeCategory:UInt32 = 0x1 << 3
}
