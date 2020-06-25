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
    private var charWalkingFrames: [SKTexture] = []
    let cam = SKCameraNode()
    
    override func didMove(to view: SKView) {
        print("Entrou na cena da Lenda da Mãe D'água")
        self.anchorPoint = .zero
        self.camera = cam
        buildChar()
        animateChar()
        self.addBackground()
    }
    
    override func didSimulatePhysics() {
        self.camera!.position = character.position
    }
    
    func addBackground(){
        let bg = SKSpriteNode(imageNamed: "horizonteBg")
        bg.position = CGPoint(x: 250, y: 250)
        self.addChild(bg)
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
        character.position = CGPoint(x: frame.midX, y: frame.midY)
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
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))

        // 3
        let doneAction = SKAction.run({ [weak self] in
          self?.charMoveEnded()
        })

        // 4
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        character.run(moveActionWithDone, withKey:"charMoving")
    }
    

}
