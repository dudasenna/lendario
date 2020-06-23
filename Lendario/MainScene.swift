//
//  GameScene.swift
//  Lendario
//
//  Created by Jéssica Amaral on 22/06/20.
//  Copyright © 2020 Jéssica Amaral. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainScene: SKScene {
    let logo = SKSpriteNode(imageNamed: "Logo")
    let background = SKSpriteNode(imageNamed: "Background")
    var lendarioName: SKLabelNode!
    var touchToBegin: SKLabelNode!
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        
        background.size = size
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.isHidden = false
        self.addChild(background)
        
        logo.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        logo.zPosition = 1
        logo.isHidden = false
        self.addChild(logo)
        
        lendarioName = SKLabelNode(fontNamed: "Xilosa")
        lendarioName.position = CGPoint(x: size.width * 0.5, y: size.height * 0.65)
        lendarioName.zPosition = 1
        lendarioName.fontSize = 36
        lendarioName.text = "Lendário"
        lendarioName.fontColor = .white
        self.addChild(lendarioName)
        
        touchToBegin = SKLabelNode(fontNamed: "Xilosa")
        touchToBegin.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        touchToBegin.zPosition = 1
        touchToBegin.fontSize = 20
        touchToBegin.text = "- Toque para começar -"
        touchToBegin.fontColor = .white
        self.addChild(touchToBegin)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lendarioName.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)){
            self.lendarioName.isHidden = true
        }
        
        logo.run(SKAction.scale(to: 0, duration: 0.3)){
            self.logo.isHidden = true
        }
        
        touchToBegin.run(SKAction.move(by: CGVector(dx: -50, dy: -100), duration: 0.5)){
            self.touchToBegin.isHidden = true
        }
    }
}
