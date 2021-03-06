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
    
//    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var currentNode: SKNode?
    
    var radiusOfMainPlayer: CGFloat = 40
    var lastRecordedPosition: CGPoint = CGPoint()
    var mainPlayer : SKShapeNode = SKShapeNode()
    
    var blueNode = SKSpriteNode(
        color: .blue,
        size: CGSize(width: 100, height: 100)
    )
    var scale: CGFloat = 0.01
    
    let mainBall: UInt32 = 0x1 << 1
    let otherColors: UInt32 = 0x1 << 0
    
    override func didMove(to view: SKView) {
        scene?.backgroundColor = .gray
        physicsWorld.contactDelegate = self
        let randomNodePosition = GKRandomDistribution(lowestValue: 0, highestValue: 400)
            let position = CGFloat(randomNodePosition.nextInt())

        
        let node = SKSpriteNode(
            color: .red,
            size: CGSize(width: 100, height: 100)
        )
        
        node.position = CGPoint(x:0 ,y:0)
        node.name = "draggable"
        self.addChild(node)
        addRandomBlueNode()
        
        
        
        
         mainPlayer = SKShapeNode(circleOfRadius: radiusOfMainPlayer)
        mainPlayer.name = "draggable"
        mainPlayer.position = CGPoint(x: position, y: self.frame.size.height/2)
        mainPlayer.physicsBody = SKPhysicsBody(rectangleOf: blueNode.size)
        mainPlayer.physicsBody?.isDynamic = true
        mainPlayer.physicsBody?.affectedByGravity = false
        mainPlayer.physicsBody?.categoryBitMask = mainBall
        mainPlayer.physicsBody?.contactTestBitMask = otherColors
        mainPlayer.physicsBody?.collisionBitMask = 0
        mainPlayer.physicsBody?.usesPreciseCollisionDetection = true

        mainPlayer.fillColor = SKColor.red
        mainPlayer.strokeColor = SKColor.red

        mainPlayer.position = CGPoint(x:200 ,y:200)
        self.addChild(mainPlayer)

    }
    
    func addRandomBlueNode() {
        let randomNodePosition = GKRandomDistribution(lowestValue: 0, highestValue: 400)
        let position = CGFloat(randomNodePosition.nextInt())
            blueNode.position = CGPoint(x: position, y: position)
            blueNode.physicsBody = SKPhysicsBody(rectangleOf: blueNode.size)
            blueNode.physicsBody?.isDynamic = true
            blueNode.physicsBody?.affectedByGravity = false
            blueNode.physicsBody?.categoryBitMask = otherColors
            blueNode.physicsBody?.contactTestBitMask = mainBall
            blueNode.physicsBody?.collisionBitMask = 0
            blueNode.physicsBody?.usesPreciseCollisionDetection = true
            blueNode.name = "draggable"
            self.addChild(blueNode)
    }
    

    func didBegin(_ contact: SKPhysicsContact) {
        print("worked")
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            print("if")
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & otherColors) != 0 && (secondBody.categoryBitMask & mainBall) != 0 {
            print("collision")
            print("hello")
            
            scale += 1.05
            mainPlayer.setScale(scale)
            blueNode.removeFromParent()
            addRandomBlueNode()
            


            
    }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
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
