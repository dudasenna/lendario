//
//  CrossroadsScene.swift
//  Lendario
//
//  Created by Fenda do Biquini on 25/06/20.
//  Copyright © 2020 Fenda do Biquini. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class CrossroadsScene: SKScene {
    
    var character = SKSpriteNode()
    var background = SKSpriteNode()
    var board = SKSpriteNode()
    
    let sky = SKSpriteNode(imageNamed: "Céu")
    let floor = SKSpriteNode(imageNamed: "Chão")
    let sun = SKSpriteNode(imageNamed: "Sol")
    
    var riverButton = UIButton()
    var soon1 = UIButton()
    var soon2 = UIButton()
    var soon3 = UIButton()
    
    private var charWalkingFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        
        //Configura o chão
        floor.size = size
        floor.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        floor.zPosition = -1
        self.addChild(floor)
        
        //Configura o céu
        sky.position = CGPoint(x: floor.position.x, y: floor.position.y + 60)
        sky.size.width = size.width
        sky.zPosition = -3
        self.addChild(sky)
        
        //Configura o sol
        sun.size = CGSize(width: sun.size.width * 1.5, height: sun.size.height * 1.5)
        sun.position = CGPoint(x: (size.width * 0.9) + 120, y: floor.position.y - 100)
        sun.zPosition = -2
        self.addChild(sun)
        
        board = SKSpriteNode(imageNamed: "Board")
        board.position = CGPoint(x: frame.width * 0.8, y: frame.height * 0.4)
        board.size = CGSize(width: board.size.width, height: board.size.height * 1.2)
        board.zPosition = 1
        self.addChild(board)
        
        riverButton.titleLabel?.font = UIFont(name: "ChelseaMarket-Regular", size: 40)
        riverButton.setTitle("Rio", for: .normal)
        riverButton.setTitleColor(.black, for: .normal)
        riverButton.isHidden = true
        riverButton.addTarget(self, action: #selector(maeDaguaTransition), for: .touchUpInside)
        view.addSubview(riverButton)
        
        //Coloca o personagem animado na tela
        buildChar()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (character.position.x >= board.position.x - 40){
            moveEnded()
        }
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
        character.position = CGPoint(x: frame.minX, y: frame.minY + character.size.height)
        character.zPosition = 2
        
        animateChar()
        
        self.addChild(character)
    }
    
    private func animateChar() {
        let walkAction = SKAction.animate(with: charWalkingFrames, timePerFrame: 0.3)
        let charWalkMove = SKAction.repeatForever(walkAction)
        let charMoveTo = SKAction.move(to: CGPoint(x: board.position.x - 40, y: character.position.y), duration: 3)
        let charWalking = SKAction.group([charWalkMove, charMoveTo])
        //let charFullMoviment = SKAction.sequence([charWalking, chara])
        character.run(charWalking)
    }
    
    private func moveEnded(){
        let charDisappear = SKAction.fadeOut(withDuration: 0.2)
        let moveBoard = SKAction.move(to: CGPoint(x: frame.midX, y: board.position.y), duration: 0.4)
        let zoomBoard = SKAction.scale(to: 1.5, duration: 0.3)
        let boardAction = SKAction.sequence([moveBoard, zoomBoard])
        
        character.run(charDisappear){
            self.board.run(boardAction){
                self.riverButton.frame = CGRect(x: self.board.position.x, y: self.board.frame.midY * 0.5, width: self.board.size.width * 0.5, height: 50)
                self.riverButton.isHidden = false
            }
        }
    }
    
    @IBAction func maeDaguaTransition(){
        riverButton.removeFromSuperview()
        self.view?.presentScene(MaeDaguaScene(size: self.size))
    }
    
}
