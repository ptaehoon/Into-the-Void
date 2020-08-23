//
//  GameScene.swift
//  Into The Void
//
//  Created by Andy Rochat on 2/9/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

class GameScene: SKScene, SKPhysicsContactDelegate, SKSceneDelegate {
    //Nodes
    var spaceShip = SKSpriteNode(imageNamed: "spaceship")
    var taptoplayLbl = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var highestScoreLabel = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var wallPair = SKNode()
    //Actions
    var moveAndRemove = SKAction()
    //GameMode: -1 is infinite randomly generated, otherwise it is levels index (levels[gameMode])
    var gameMode = -1
    //marginOfError: percentage of player height allowed between gaps.
    var marginOfError = CGFloat(1)
    //noteIndex: index of the note in each level
    var noteIndex = 0
    //player status: 0:
    var isGameStarted = false
    var isDied = false
    //reference to the GameViewController
    var gameViewController: GameViewController!
    var level: [Note]?
    var counter = 0
    var currScore = 0 {
        didSet{
            //update label for current score
            updateUIAfterPassing()
            if(gameMode == -1){
                if(currScore > CurrentUser.instance.highestScore){
                    CurrentUser.instance.highestScore = currScore
                    CurrentUser.instance.setHighScore(score: currScore)
                }
            }
        }
    }
    var extraLife = 0
    
    override func didMove(to view: SKView){
        createScene()
    }
    
    func createScene(){
        //physicsbody for the world
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        /*
         .        Collision prevents objects from intersecting.
         Contact is for notifying us when two objects touch.
         */
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.spaceshipCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.spaceshipCategory
        self.physicsBody?.isDynamic = false
        
        //Turn off gravity
        self.physicsBody?.affectedByGravity = false
        //delegate contact to be able to be notified when contact happens
        self.physicsWorld.contactDelegate = self
        
        self.spaceShip = createSpaceship()
        self.addChild(spaceShip)
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
        
        scoreLabel = createScoreLabel()
        highestScoreLabel = createHighScoreLabel()
        self.addChild(scoreLabel)
        if(gameMode == -1){
            self.addChild(highestScoreLabel)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //counter = 1
        if(isGameStarted == false){
            isGameStarted = true
            createPauseBtn()
            taptoplayLbl.removeFromParent()
            //if it is Infinite Mode
            if(gameMode == -1){
                startInfiniteMode()
            } else {
                startLevelMode()
            }
        }else{
            if(isDied == false){
                
            }
        }
        
        for t in touches{
            let locationOfBtn = t.location(in: self)
            //Check touches location to see if it is contained inside the restart or pause button. If the game ends(Space ship dies) then the user is only allowed to interact with restart button. When the restart button is slicked,
            if isDied == true{
                if restartBtn.contains(locationOfBtn){
                    restartScene()
                }
            }else{
                if pauseBtn.contains(locationOfBtn){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseGame()
                    }else{
                        self.isPaused = false
                    }
                }
            }
        }
    }
    //function called once per frame
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func startInfiniteMode(){
        CurrentUser.instance.insideNote = false
        //spawn pillers
        let spawn = SKAction.run({
            () in
            self.wallPair = self.createRandomWalls()
            self.addChild(self.wallPair)
            if((4 < self.counter) && (self.counter <= 10)){

                let distance = CGFloat(self.frame.width + self.wallPair.frame.width)
                let movePillars = SKAction.moveBy(x: -distance - 50, y: -40, duration: TimeInterval(0.025 * distance))
                let removePillars = SKAction.removeFromParent()
                //Creates an action that runs a collection of actions sequentially.
                self.moveAndRemove = SKAction.sequence([movePillars, removePillars])
            }else if((10 < self.counter) && (self.counter <= 15)){

                let distance = CGFloat(self.frame.width + self.wallPair.frame.width)
                let movePillars = SKAction.moveBy(x: -distance - 50, y: +80, duration: TimeInterval(0.025 * distance))
                let removePillars = SKAction.removeFromParent()
                //Creates an action that runs a collection of actions sequentially.
                self.moveAndRemove = SKAction.sequence([movePillars, removePillars])
            }else if((15 < self.counter) && (self.counter <= 20)){

                let distance = CGFloat(self.frame.width + self.wallPair.frame.width)
                let movePillars = SKAction.moveBy(x: -distance - 50, y: -120, duration: TimeInterval(0.025 * distance))
                let removePillars = SKAction.removeFromParent()
                //Creates an action that runs a collection of actions sequentially.
                self.moveAndRemove = SKAction.sequence([movePillars, removePillars])
            }else if((20 < self.counter)){

                let distance = CGFloat(self.frame.width + self.wallPair.frame.width)
                let movePillars = SKAction.moveBy(x: -distance - 50, y: +160, duration: TimeInterval(0.025 * distance))
                let removePillars = SKAction.removeFromParent()
                //Creates an action that runs a collection of actions sequentially.
                self.moveAndRemove = SKAction.sequence([movePillars, removePillars])
            }
        })
        
        //2- Here you wait for 1.5 seconds for the next set of pillars to be generated. A sequence of actions will run the spawn and delay actions forever.
        let baseSpeed = Double(CurrentUser.instance.baseSpeedGetter()/3.0)
        print(baseSpeed)
        
        let delay = SKAction.wait(forDuration: 5/baseSpeed)
        let SpawnDelay = SKAction.sequence([spawn, delay])
        let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
        self.run(spawnDelayForever)
        self.removeAction(forKey: "spawnDelayForever")
        
        let distance = CGFloat(self.frame.width + self.wallPair.frame.width)
        print(distance)
        let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.025 * distance)/baseSpeed)
        let removePillars = SKAction.removeFromParent()
        //Creates an action that runs a collection of actions sequentially.
        self.moveAndRemove = SKAction.sequence([movePillars, removePillars])
    }
    
    func startLevelMode(){
        //spawn pillers
        CurrentUser.instance.insideNote = false
        let spawn = SKAction.run({
            () in
            if self.noteIndex < self.level!.count{
                self.wallPair = self.createNoteWallPair(note: self.level![self.noteIndex])
                self.addChild(self.wallPair)
                self.noteIndex += 1
            } else {
                self.noteIndex = 0
            }
        })
        
        //2- Here you wait for 1.5 seconds for the next set of pillars to be generated. A sequence of actions will run the spawn and delay actions forever.
        let baseSpeed = Double(CurrentUser.instance.baseSpeedGetter()/3.0)
        print(baseSpeed)
        
        let delay = SKAction.wait(forDuration: 5/baseSpeed)
        let SpawnDelay = SKAction.sequence([spawn, delay])
        let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
        self.run(spawnDelayForever)
        
        //3- This will move and remove the pillars. You set the distance that the pillars have to move which is the sum of the screen and the pillar width. Another sequence of action will run in order to move and remove the pillars. Pillars start moving to the left of the screen as they are created and are deallocated when they go off the screen.
        

        
        let distance = CGFloat(self.frame.width + wallPair.frame.width)
        
        let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.025 * distance)/baseSpeed)
        
//        let speed = Float(3.0*0.025*distance) / CurrentUser.instance.baseSpeedGetter()
//        let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(Double(speed)))
        
        let removePillars = SKAction.removeFromParent()
        //Creates an action that runs a collection of actions sequentially.
        
        moveAndRemove = SKAction.sequence([movePillars, removePillars])
    }
    
    //map the frequency of the note to its y position on screen based on user's highest and lowest note
    func mapFreqToY(freq: CGFloat) -> CGFloat {
        let userLowestFreq = CurrentUser.instance.lowestNote.freq
        let userHighestFreq = CurrentUser.instance.highestNote.freq
        //TODO: if the freq is out of range defined by user, map to the end points
        
        //this counts for the pixels spaceship takes up
        let deltaFreqFromBottom = freq - userLowestFreq
        let userRange = userHighestFreq - userLowestFreq
        let screenHeight = (view?.bounds.size.height)!
        var newY = (deltaFreqFromBottom / userRange) * ((screenHeight - spaceShip.size.height))
        newY +=  spaceShip.size.height / 2
        return newY
    }
    
    //Called when two bodies first contact each other.
    func didBegin(_ contact: SKPhysicsContact) {
        print("didBegin contact")
       
        let spaceShip = contact.bodyA.categoryBitMask == CollisionBitMask.spaceshipCategory ? contact.bodyA : contact.bodyB
        let secondBody = contact.bodyA.categoryBitMask == CollisionBitMask.spaceshipCategory ? contact.bodyB : contact.bodyA
        print("secondBody Mask: \(secondBody.categoryBitMask)")
        print("pillar mask: \(CollisionBitMask.pillarCategory)")
        
        //if it is between spaceship and pillar
        if secondBody.categoryBitMask == CollisionBitMask.pillarCategory {
            if extraLife > 0 {
                extraLife = extraLife - 1
                secondBody.node?.removeFromParent()
            }
            else {
                diedGame()
            }
        }
        
        //if it is between spaceship and a centerNode
        if secondBody.categoryBitMask == CollisionBitMask.centerNodeCategory {
            print("still in")
            //TODO: ideally some animation here
            
            if(gameMode != -1){
                CurrentUser.instance.insideNote = !CurrentUser.instance.insideNote
            }
            
            if secondBody.node?.name! == "powerupNode" {
                secondBody.node?.removeFromParent()
                extraLife = extraLife + 1
            }
            else if secondBody.node?.name! == "pointsNode" {
                secondBody.node?.removeFromParent()
                currScore += 2
            }
            else if secondBody.node?.name! == "afterNode" {
                secondBody.node?.removeFromParent()
            }
            else {
                secondBody.node?.removeFromParent()
                currScore += 1
                //check if it is the last note of the level (if it is not infinite mode)
                if(gameMode != -1){
                    if let lv = level {
                        if noteIndex >= lv.count {
                            endGame()
                        }
                    }
                }
            }
        }
        
        print("end of contact")
    }
    
    func createMovingBackground(){
        //Wait to be finished for R&D feature
        for i in 0 ..< 2{
            //Creates two instances of background node and places them side by side. First image covers the screen while the second is just next to it. For endless background effect, the images move left continuously and as soon as the second image reaches the end, the first image is repositioned to the right, and so on.
            
            //This gives the appearance of a seamless moving background.
            let background = SKSpriteNode(imageNamed: "spaceBackground")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            //gets repositions to the right?
            self.addChild(background)
        }
    }
    
    //function handles UI updates after passing a wallpair
    func updateUIAfterPassing(){
        scoreLabel.text = "Score \(currScore)"
    }
    
    func pauseGame(){
        gameViewController.displayPulseScreen()
    }
    
    func resumeGame(){
        
    }
    
    func endGame(){
        //TODO: display "finish the level screen"
        enumerateChildNodes(withName: "wallPair", using: ({
            (node, error) in
            node.speed = 0
            self.removeAllActions()
        }))
        gameViewController.displayEndScreen()
    }
    
    func diedGame(){
        enumerateChildNodes(withName: "wallPair", using: ({
            (node, error) in
            node.speed = 0
            self.removeAllActions()
        }))
        counter = 0
        currScore = 0
        if isDied == false{
            isDied = true
            self.spaceShip.removeAllActions()
            pauseBtn.removeFromParent()
        }
        gameViewController.displayDeadScreen()
    }
}

extension GameScene {
    func createNoteWallPair(note: Note) -> SKNode {
        wallPair = SKNode()
        wallPair.name = "wallPair"

        var topWall = SKSpriteNode(imageNamed: "spacePillar")
        var btmWall = SKSpriteNode(imageNamed: "spacePillar")
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        //scale this up so they can cover the whole screen for very low / very high notes
        topWall.size.height = topWall.size.height * 4
        btmWall.size.height = btmWall.size.height * 4
        let wallHeight = topWall.size.height
        let playerHeight = spaceShip.size.height
        //if this note in the level is beyond the range, we change its octave so it's within the user's voice range
        var note = note
        if(note.freq > CurrentUser.instance.highestNote.freq){
            note = note.subTractOctave()
        } else if(note.freq < CurrentUser.instance.lowestNote.freq){
            note = note.addOctave()
        }
        //if somehow the above doesn't work (given that user's voice range does not cover an entire octave, we generate pillars randomly
        if(note.freq > CurrentUser.instance.highestNote.freq || note.freq < CurrentUser.instance.lowestNote.freq){
            return createRandomWalls()
        }
        //this is where we want to leave the gap
        let noteY = mapFreqToY(freq:note.freq)
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: noteY + wallHeight / 2 + (playerHeight / 2) * (1 + marginOfError))
        btmWall.position = CGPoint(x: self.frame.width + 25, y: noteY - wallHeight / 2 - (playerHeight / 2) * (1 + marginOfError))
        topWall = configureWallPhysicsBody(wall: topWall)
        btmWall = configureWallPhysicsBody(wall: btmWall)
        
        let centerNode = createCenterNode(note: note, width: topWall.size.width)
        centerNode.position = CGPoint(x: self.frame.width + 25, y: noteY)
        
        let afterNode = createAfterNode()
        afterNode.position = CGPoint(x: self.frame.width + 145, y: noteY)
        
        //rotate top pillar upside down
        topWall.zRotation = CGFloat(CGFloat.pi)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        wallPair.addChild(centerNode)
        wallPair.addChild(afterNode)
        wallPair.zPosition = 1
        wallPair.run(moveAndRemove)
        
        return wallPair
    }

    
    func createRandomWalls() -> SKNode {
        wallPair = SKNode()
        wallPair.name = "wallPair"
        counter += 1
        
        var topWall = SKSpriteNode(imageNamed: "spacePillar")
        var btmWall = SKSpriteNode(imageNamed: "spacePillar")
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.size.height = topWall.size.height * 4
        btmWall.size.height = btmWall.size.height * 4
        let wallHeight = topWall.size.height
        let playerHeight = spaceShip.size.height
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + wallHeight / 2 + (playerHeight / 2) * (1 + marginOfError))
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - wallHeight / 2 - (playerHeight / 2) * (1 + marginOfError))
        
        topWall = configureWallPhysicsBody(wall: topWall)
        btmWall = configureWallPhysicsBody(wall: btmWall)
        
        let centerNode = createCenterNode(note: nil, width: topWall.size.width)
        centerNode.position = CGPoint(x: self.frame.width + 25, y: (topWall.position.y +  btmWall.position.y) / 2)
       
        topWall.zRotation = CGFloat(CGFloat.pi)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        wallPair.addChild(centerNode)
        
        let number = Int.random(in: 0 ..< 10)
        if number == 1 {
            // powerup node
            let powerupNode = createPowerUpNode()
            powerupNode.position = CGPoint(x: self.frame.width + 25, y: (topWall.position.y +  btmWall.position.y) / 2)
            wallPair.addChild(powerupNode)
        }
        else if number == 2 {
            //points node
            let pointsNode = createPointsNode()
            pointsNode.position = CGPoint(x: self.frame.width + 25, y: (topWall.position.y +  btmWall.position.y) / 2)
            wallPair.addChild(pointsNode)
        }
        
        wallPair.zPosition = 1
        // 3
        let randomPosition = random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + CGFloat(randomPosition)
        //wallPair.addChild(flowerNode)
        wallPair.run(moveAndRemove)
        return wallPair
    }
    
    func configureWallPhysicsBody(wall: SKSpriteNode) -> SKSpriteNode{
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        wall.physicsBody?.collisionBitMask = CollisionBitMask.spaceshipCategory
        wall.physicsBody?.contactTestBitMask = CollisionBitMask.spaceshipCategory
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.affectedByGravity = false
        return wall
    }
    
    func createCenterNode(note: Note?, width: CGFloat) -> SKSpriteNode {
        if let nt = note {
            //if not null
            let centerNode = SKSpriteNode()
            centerNode.name = "centerNode"
            centerNode.size = CGSize(width: width, height: spaceShip.size.height  * (1 + marginOfError))
            centerNode.physicsBody = SKPhysicsBody(rectangleOf: centerNode.size)
            centerNode.physicsBody?.categoryBitMask = CollisionBitMask.centerNodeCategory
            centerNode.physicsBody?.contactTestBitMask = CollisionBitMask.spaceshipCategory
            centerNode.physicsBody?.isDynamic = false
            centerNode.physicsBody?.affectedByGravity = false
            let centerLabel = SKLabelNode()
            centerLabel.name = "wallLabel"
            centerLabel.text = nt.name
            centerLabel.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
            centerLabel.zPosition = 5
            centerLabel.fontSize = 40
            centerLabel.fontName = "HelveticaNeue"
            centerLabel.horizontalAlignmentMode = .center
            centerLabel.verticalAlignmentMode = .center
            centerNode.addChild(centerLabel)
//            centerNode.color = .white
            return centerNode
        } else {
            //if null: no note
            let centerNode = SKSpriteNode()
            centerNode.name = "centerNode"
            centerNode.size = CGSize(width: width, height: spaceShip.size.height  * (1 + marginOfError))
            centerNode.physicsBody = SKPhysicsBody(rectangleOf: centerNode.size)
            centerNode.physicsBody?.categoryBitMask = CollisionBitMask.centerNodeCategory
            centerNode.physicsBody?.contactTestBitMask = CollisionBitMask.spaceshipCategory
            centerNode.physicsBody?.isDynamic = false
            centerNode.physicsBody?.affectedByGravity = false
            return centerNode
        }
    }
    func createAfterNode() -> SKSpriteNode {
        let afterNode = SKSpriteNode()
        afterNode.name = "afterNode"
        afterNode.size = CGSize(width: 5, height: spaceShip.size.height  * (1 + marginOfError))
        afterNode.physicsBody = SKPhysicsBody(rectangleOf: afterNode.size)
        afterNode.physicsBody?.categoryBitMask = CollisionBitMask.centerNodeCategory
        afterNode.physicsBody?.contactTestBitMask = CollisionBitMask.spaceshipCategory
        afterNode.physicsBody?.isDynamic = false
        afterNode.physicsBody?.affectedByGravity = false
//        afterNode.color = .white
        return afterNode
    }
    func createPowerUpNode() -> SKSpriteNode {
        let afterNode = SKSpriteNode()
        afterNode.name = "powerupNode"
        afterNode.size = CGSize(width: 40, height: spaceShip.size.height)
        afterNode.physicsBody = SKPhysicsBody(rectangleOf: afterNode.size)
        afterNode.physicsBody?.categoryBitMask = CollisionBitMask.centerNodeCategory
        afterNode.physicsBody?.contactTestBitMask = CollisionBitMask.spaceshipCategory
        afterNode.physicsBody?.isDynamic = false
        afterNode.physicsBody?.affectedByGravity = false
        afterNode.color = .blue
        return afterNode
    }
    
    func createPointsNode() -> SKSpriteNode {
        let afterNode = SKSpriteNode()
        afterNode.name = "pointsNode"
        afterNode.size = CGSize(width: 40, height: spaceShip.size.height)
        afterNode.physicsBody = SKPhysicsBody(rectangleOf: afterNode.size)
        afterNode.physicsBody?.categoryBitMask = CollisionBitMask.centerNodeCategory
        afterNode.physicsBody?.contactTestBitMask = CollisionBitMask.spaceshipCategory
        afterNode.physicsBody?.isDynamic = false
        afterNode.physicsBody?.affectedByGravity = false
        afterNode.color = .orange
        return afterNode
    }
    
    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.name = "taptoplayLbl"
        taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 20
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }
    func createScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode()
        scoreLabel.name = "scoreLabel"
        scoreLabel.position = CGPoint(x:self.frame.midX, y:self.frame.size.height - 100)
        scoreLabel.text = "Score \(currScore)"
        scoreLabel.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        scoreLabel.zPosition = 5
        scoreLabel.fontSize = 20
        scoreLabel.fontName = "HelveticaNeue"
        return scoreLabel
    }
    func createHighScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode()
        scoreLabel.name = "scoreLabel"
        scoreLabel.position = CGPoint(x:100, y:self.frame.size.height - 100)
        scoreLabel.text = "Record: \(Int(UserDefaults.standard.double(forKey: "highScore"))) "
        scoreLabel.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        scoreLabel.zPosition = 5
        scoreLabel.fontSize = 20
        scoreLabel.fontName = "HelveticaNeue"
        return scoreLabel
    }
    //1
    func createRestartBtn(){
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width: 100, height: 100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        //Score section?
        createScene()
    }
    
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:40, height:40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    
    func createSpaceship() -> SKSpriteNode{
        
        //size of 100 * 100
//        let spaceShip = SKSpriteNode(imageNamed: "spaceship") commented out by DLT
        
        let spaceShip = mainInstance.currentPlayerImage;
        spaceShip.removeFromParent()
        
        spaceShip.size = CGSize(width: 100, height: 100)
        spaceShip.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        spaceShip.physicsBody = SKPhysicsBody(circleOfRadius: spaceShip.size.width / 2)
        spaceShip.physicsBody?.linearDamping = 1.1
        spaceShip.physicsBody?.restitution = 0
        
        //3
        //A birdCategory is assigned to the player categoryBitMask property. If two bodies collide, we identify the two bodies by their categoryBitMasks. The collisionBitMask is set to pillarCategory and groundCategory to detect collisions with pillar and ground for this body. The contactTestBitMask is assigned to pillar, ground, ground, and flower because you will want to check for contacts with these bodies.
        spaceShip.physicsBody?.categoryBitMask = CollisionBitMask.spaceshipCategory
        spaceShip.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        spaceShip.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory | CollisionBitMask.centerNodeCategory
        
        //4
        //Here you set the bird to not be affect by gravity.
        spaceShip.physicsBody?.affectedByGravity = false
        spaceShip.physicsBody?.isDynamic = true //affected by physics
        
        return spaceShip
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFE)
    }
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
}
