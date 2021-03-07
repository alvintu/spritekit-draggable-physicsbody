//
//  GameScene.swift
//  NumbersGame
//
//  Created by Alvin Tu on 2/6/21.
//  Copyright © 2021 Alvin Tu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    private var currentNode: SKNode?
    
    var count = 0
    var gameScoreLabel = SKLabelNode()
    
    var radiusOfMainPlayer: CGFloat = 10
    var lastRecordedPosition: CGPoint = CGPoint()
    var mainPlayer : SKShapeNode?
    

    var scale: CGFloat = 1.0
    
    let mainBall: UInt32 = 0x1 << 0
    let otherBalls: UInt32 = 0x1 << 1
    
    override func didMove(to view: SKView) {
        scene?.backgroundColor = .gray
        physicsWorld.contactDelegate = self
        view.showsFPS = false
        view.showsNodeCount = false
        addMainPlayer()
        gameScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameScoreLabel.text = "\(count)"
        gameScoreLabel.fontSize = 30
        gameScoreLabel.position = CGPoint(x:frame.midX, y: frame.midY)
        gameScoreLabel.isUserInteractionEnabled = false
       self.addChild(gameScoreLabel)
        

        add(blueNodesAmount: 400)
        
    }
    
    func addMainPlayer() {
        mainPlayer = SKShapeNode(circleOfRadius: radiusOfMainPlayer)
        mainPlayer!.name = "draggable"
        mainPlayer!.position = CGPoint(x:frame.midX, y: frame.midY)
        mainPlayer!.physicsBody = SKPhysicsBody(rectangleOf: mainPlayer!.frame.size)
        mainPlayer!.physicsBody?.isDynamic = true
        mainPlayer!.physicsBody?.affectedByGravity = false
        mainPlayer!.physicsBody?.categoryBitMask = mainBall
        mainPlayer!.physicsBody?.contactTestBitMask = otherBalls
        mainPlayer!.physicsBody?.collisionBitMask = 0
        mainPlayer!.physicsBody?.usesPreciseCollisionDetection = true

        mainPlayer!.fillColor = SKColor.red
        mainPlayer!.strokeColor = SKColor.red
        self.addChild(mainPlayer!)

    }
    func add(blueNodesAmount:Int) {
        for _ in 0...blueNodesAmount {
            addRandomBlueNode()
        }
    }
    
    fileprivate func addRandomBlueNode() {
        let blueNode = SKSpriteNode(
            color: .blue,
            size: CGSize(width: 25, height: 25)
        )
        let width = scene!.frame.width
        let height = scene!.frame.height
        let randomNodeXPosition = GKRandomDistribution(lowestValue: Int(-width)/2, highestValue: Int(width)/2)
        let randomNodeYPosition = GKRandomDistribution(lowestValue: Int(-height)/2, highestValue: Int(height)/2)
        let positionX = CGFloat(randomNodeXPosition.nextInt())
        let positionY = CGFloat(randomNodeYPosition.nextInt())
            blueNode.position = CGPoint(x: positionX, y: positionY)
        print(blueNode.position)
            blueNode.physicsBody = SKPhysicsBody(rectangleOf: blueNode.size)
            blueNode.physicsBody?.isDynamic = true
            blueNode.physicsBody?.affectedByGravity = false
            blueNode.physicsBody?.categoryBitMask = otherBalls
            blueNode.physicsBody?.contactTestBitMask = mainBall
            blueNode.physicsBody?.collisionBitMask = 0
            blueNode.physicsBody?.usesPreciseCollisionDetection = true
            self.addChild(blueNode)
    }
    

    func didBegin(_ contact: SKPhysicsContact) {
        print("worked")
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & mainBall) != 0 && (secondBody.categoryBitMask & otherBalls) != 0 {
            mainPlayerDidCollideWithOtherBall(mainPlayer:firstBody.node as! SKShapeNode, otherBall: secondBody.node as! SKSpriteNode)
            
                    
    }
    }
    
    func mainPlayerDidCollideWithOtherBall(mainPlayer:SKShapeNode, otherBall: SKSpriteNode) {
    
//        scale += 1.0
//        print(scale)
        
        
        mainPlayer.setScale(scale)
        otherBall.removeFromParent()
        if scale < 60 {
            count += 1
            gameScoreLabel.text = "\(count)"
            addRandomBlueNode()

        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.mainPlayer?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.mainPlayer?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
        }
    }
    
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            lastRecordedPosition = location

            let touchedNodes = self.nodes(at: location)
            for node in touchedNodes.reversed() {
                if node.name == "draggable" {
                    self.currentNode = node

                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
        if let touch = touches.first, let node = self.currentNode {
            let touchLocation = touch.location(in: self)
            node.position = touchLocation
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        self.currentNode = nil

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
