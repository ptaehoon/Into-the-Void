//
//  GameScene.swift
//  Test2
//
//  Created by Yang on 2/17/20.
//  Copyright © 2020 apple－pc. All rights reserved.
//

import Foundation
import SpriteKit

//extension Double {
//    var cg: CGFloat { return CGFloat(self) }
//}
//
//extension Int {
//    var cg: CGFloat { return CGFloat(self) }
//}
//
//func randomInt(range: Range<Int>) -> Int {
//    return range.startIndex + Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex)))
//}
//
//extension Array {
//    func randomElement() -> Element? {
//        switch self.count {
//        case 0: return nil
//        default: return self[randomInt(range: 0..<self.count)]
//        }
//    }
//
//    func apply<Ignore>(f:(Element) -> (Ignore)) {
//        for e in self { f(e) }
//    }
//}

class GameScene: SKScene{
    let player = SKSpriteNode(imageNamed: "player")
    
    //    used https://stackoverflow.com/questions/26082775/moving-multiple-sprite-nodes-at-once-on-swift
    var screenWidth: CGFloat { return UIScreen.main.bounds.size.width }
    var screenHeight: CGFloat { return UIScreen.main.bounds.size.height }

    let PlatformName = "Platform"
    let FallenPlatformName = "FallenPlatform"

    func createRectangle(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> SKShapeNode {
        let rect = CGRect(x: x, y: y, width: width, height: height)
        let path = UIBezierPath(rect: rect)
        let node = SKShapeNode(path: path.cgPath)
        print("*******")
        print(node.frame.minY)
        print(node.frame.maxY)
        
//        https://stackoverflow.com/questions/33984078/adding-physic-bodies-to-spritekit-nodes
        
//        node.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
//        node.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
//        node.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
//        node.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
//        node.physicsBody?.isDynamic = false
//        node.physicsBody?.affectedByGravity = false
        
        return node
    }
    
    func createObstacle(lowerBound: CGFloat, upperBound: CGFloat) -> (SKShapeNode,SKShapeNode) {
        let desiredWidth:CGFloat = 25.0
        let topObstacle = createRectangle(x: screenWidth, y: 0, width: desiredWidth, height: screenHeight-upperBound)
        let botObstacle = createRectangle(x: screenWidth, y: screenHeight-lowerBound, width: desiredWidth, height: screenHeight)
        
        topObstacle.fillColor = SKColor.black
        topObstacle.name = PlatformName
        botObstacle.fillColor = SKColor.black
        botObstacle.name = PlatformName
        
        //will need to switch to this soon
        //        var obsPair = SKNode()

        
        return (topObstacle,botObstacle)
    }

    func createObstacleSet() -> [(SKShapeNode,SKShapeNode)] {
        
        print(screenHeight)
        
        let obstacle1 = createObstacle(lowerBound: 100, upperBound: 200)
        let obstacle2 = createObstacle(lowerBound: 500, upperBound: 600)
        let obstacle3 = createObstacle(lowerBound: 300, upperBound: 400)
        
        let nodes:[(SKShapeNode,SKShapeNode)] = [obstacle1,obstacle2,obstacle3]
        return nodes
    }

    func moveObstacle(by: CGFloat, duration: TimeInterval, timeGap: TimeInterval, range: TimeInterval = 0) -> SKAction {

        let gap = SKAction.wait(forDuration: timeGap, withRange: range)
        let fall = SKAction.moveBy(x: -by, y: 0, duration: duration)
        let next = SKAction.customAction(withDuration: 0) { [unowned self]
            node, time in
            node.name = self.FallenPlatformName
        }

        return SKAction.sequence([gap, fall, next])
    }

    func startObstacleMovement(obstacleList: [(SKShapeNode,SKShapeNode)]) {
        
        let obstacleWidth:CGFloat = obstacleList[0].0.frame.width+5
        print("obstacle width")
        print(obstacleWidth)
        var waitTime:Double = 0
        
        for ob in obstacleList {
            let (ob1, ob2) = ob
            let movement1 = moveObstacle(by: screenWidth+obstacleWidth, duration: 3, timeGap: waitTime, range: 0)
            let movement2 = moveObstacle(by: screenWidth+obstacleWidth, duration: 3, timeGap: waitTime, range: 0)
            ob1.run(movement1)
            ob2.run(movement2)
            
            waitTime = waitTime + 2.5
        }
    }

    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.green
        let obstacleList = createObstacleSet()
        for (ob1,ob2) in obstacleList {
            self.addChild(ob1)
            self.addChild(ob2)
        }
        startObstacleMovement(obstacleList: obstacleList)
        
//        backgroundColor = SKColor.black
        let size = CGSize(width: 100, height: 100)
        player.scale(to: size)
        player.position = CGPoint(x: size.width, y: size.height)
        addChild(player)
    }
}

