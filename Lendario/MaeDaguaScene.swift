//
//  File.swift
//  Lendario
//
//  Created by Fenda do Biquini on 25/06/20.
//  Copyright © 2020 Fenda do Biquini. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class MaeDaguaScene: SKScene {
    private var character = SKSpriteNode()
    var background1 = SKSpriteNode()
    var background2 = SKSpriteNode()
    
    private var charWalkingFrames: [SKTexture] = []
    
    let cam = SKCameraNode()
    
    var charVelocity: CGFloat = 0
    
    override func didMove(to view: SKView) {
        buildChar()
        
        cam.position = character.position
        self.addChild(cam)
        self.camera = cam
        
        //background setup
        background1 = SKSpriteNode(imageNamed: "BackgroundDia")
        background1.anchorPoint = self.anchorPoint
        background1.position = CGPoint.zero
        background1.size = CGSize(width: background1.frame.width, height: size.height * 1.05)
        print(background1.size)
        background1.zPosition = -1
        self.addChild(background1)
        
        //background setup
        background2 = SKSpriteNode(imageNamed: "BackgroundNoite")
        background2.anchorPoint = self.anchorPoint
        background2.position = CGPoint(x: background1.position.x + background1.frame.width, y: 0)
        background2.size = CGSize(width: background2.frame.width, height: background1.frame.height)
        background2.zPosition = -1
        self.addChild(background2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        cam.position = character.position
        character.physicsBody?.velocity.dx = charVelocity
        //updateBackground()
    }
    
    private func updateBackground(){
        if(cam.position.x > background1.position.x + background1.size.width * 1.5){
            if charVelocity > 0 {
                background1.position = CGPoint(x: background2.position.x + background2.size.width, y: background1.position.y)
            }
        }
        
        if(cam.position.x > background2.position.x + background2.size.width * 1.5){
            if charVelocity > 0 {
                 background2.position = CGPoint(x: background1.position.x + background1.size.width, y: background2.position.y)
            }
        }
    }
    
    /*override func didSimulatePhysics() {
        cam.position = character.position
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        var multiplierForDirection: CGFloat
        
        character.isPaused = false
        animateChar()
        
        //Define a distância que o personagem irá percorrer, baseada no clique
        let moveDifference = CGFloat(location.x - character.position.x)
        
        //Checa se o clique foi à esquerda ou à direita da posição atual do personagem
        if moveDifference < 0 {
            charVelocity = -200
            multiplierForDirection = -1
        } else {
            charVelocity = 200
            multiplierForDirection = 1
        }
        
        character.xScale = abs(character.xScale) * multiplierForDirection
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        charVelocity = 0
        charMoveEnded()
    }
    
    private func buildChar() {
        let charAnimatedAtlas = SKTextureAtlas(named: "character")
        var walkFrames: [SKTexture] = []
        
        let numImages = charAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let charTextureName = "female_walk\(i)"
            walkFrames.append(charAnimatedAtlas.textureNamed(charTextureName))
        }
        charWalkingFrames = walkFrames
        
        let firstFrameTexture = charWalkingFrames[0]
        character = SKSpriteNode(texture: firstFrameTexture)
        character.position = CGPoint(x: background1.position.x + character.size.width, y: frame.midY + 20)
        character.zPosition = 1
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.affectedByGravity = false
        self.addChild(character)
        
    }
    
    private func animateChar() {
        character.run(SKAction.repeatForever(
            SKAction.animate(with: charWalkingFrames,
                             timePerFrame: 0.2,
                             resize: false,
                             restore: false)),
                      withKey:"walkingInPlaceChar")
    }
    
    private func charMoveEnded() {
        character.isPaused = true
    }
    
    /*
     Jéssica: Código que Dara fez inicialmente, caso dê algum problema com o que fiz (vai que?)
     
     override func didMove(to view: SKView) {
         print("Entrou na cena da Lenda da Mãe D'água")
         self.anchorPoint = .zero
         self.camera = cam
         buildChar()
        // animateChar()
         
         //background setup
         background1 = SKSpriteNode(imageNamed: "backgroundRio")
         background1.anchorPoint = CGPoint.zero
         background1.position = CGPoint.zero
         background1.zPosition = -1
         self.addChild(background1)
         
         //background setup
         background2 = SKSpriteNode(imageNamed: "backgroundRio2")
         background2.anchorPoint = CGPoint.zero
         background2.position = CGPoint(x: background1.frame.width, y: 0)
         background2.zPosition = -1
         self.addChild(background2)


     }
     
     override func update(_ currentTime: TimeInterval) {
         updateBackground()
     }
     
     func updateBackground(){
         if(cam.position.x > background1.position.x + background1.size.width + 400){
             background1.position = CGPoint(x: background2.position.x+background2.size.width, y: background1.position.y)
         }
         
         if(cam.position.x > background2.position.x + background2.size.width + 400){
             background2.position = CGPoint(x: background1.position.x+background1.size.width, y: background2.position.y)
         }
         
         
     }

     override func didSimulatePhysics() {
         self.camera!.position = character.position
     }

     func buildChar() {
       let charAnimatedAtlas = SKTextureAtlas(named: "character")
       var walkFrames: [SKTexture] = []

       let numImages = charAnimatedAtlas.textureNames.count
       for i in 1...numImages {
         let charTextureName = "female_walk\(i)"
         walkFrames.append(charAnimatedAtlas.textureNamed(charTextureName))
       }
       charWalkingFrames = walkFrames

         let firstFrameTexture = charWalkingFrames[0]
         character = SKSpriteNode(texture: firstFrameTexture)
         character.position = CGPoint(x: frame.midX, y: frame.midY + 20)
         character.zPosition = 1
         addChild(character)

     }

     func animateChar() {
       character.run(SKAction.repeatForever(
         SKAction.animate(with: charWalkingFrames,
                          timePerFrame: 0.2,
                          resize: false,
                          restore: true)),
         withKey:"walkingInPlaceChar")
     }

     func charMoveEnded() {
       character.removeAllActions()
     }
     
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         let touch = touches.first!
         let location = touch.location(in: self)
         moveChar(location: location)
     }
     
     func moveChar(location: CGPoint) {
       // 1
       var multiplierForDirection: CGFloat

       // 2
       let charSpeed = frame.size.width / 3.0

       // 3
       let moveDifference = CGPoint(x: location.x - character.position.x, y: location.y - character.position.y)
       let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)

       // 4
       let moveDuration = distanceToMove / charSpeed

       // 5
       if moveDifference.x < 0 {
         multiplierForDirection = -1.0
       } else {
         multiplierForDirection = 1.0
       }
       character.xScale = abs(character.xScale) * multiplierForDirection

         // 1
         if character.action(forKey: "walkingInPlaceChar") == nil {
           // if legs are not moving, start them
           animateChar()
         }

         // 2
         //let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))
         let moveAction = SKAction.moveTo(x: location.x, duration: (TimeInterval(moveDuration)))

         // 3
         let doneAction = SKAction.run({ [weak self] in
           self?.charMoveEnded()
         })

         // 4
         let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
         character.run(moveActionWithDone, withKey:"charMoving")
     }
     */
}

