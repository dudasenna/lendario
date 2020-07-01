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
    var board = SKSpriteNode()
    
    let sky = SKSpriteNode(imageNamed: "Céu")
    let floor = SKSpriteNode(imageNamed: "Chão")
    let sun = SKSpriteNode(imageNamed: "Sol")
    
    var makeYourChoice = UILabel()
    
    var riverButton = UIButton()
    var cityButton = UIButton()
    var forestButton = UIButton()
    var sertaoButton = UIButton()
    
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
        
        makeYourChoice.frame = CGRect(x: frame.minX , y: size.height * 0.075, width: frame.width, height:  30)
        makeYourChoice.font = UIFont(name: "ChelseaMarket-Regular", size: 30)
        makeYourChoice.textColor = .white
        makeYourChoice.text = "Para onde você gostaria de ir?"
        makeYourChoice.textAlignment = .center
        makeYourChoice.lineBreakMode = .byWordWrapping
        makeYourChoice.numberOfLines = 0
        makeYourChoice.isHidden = true
        view.addSubview(makeYourChoice)
        
        riverButton.titleLabel?.font = UIFont(name: "ChelseaMarket-Regular", size: 30)
        riverButton.setTitle("Rio", for: .normal)
        riverButton.setTitleColor(.black, for: .normal)
        riverButton.isHidden = true
        riverButton.addTarget(self, action: #selector(maeDaguaTransition), for: .touchUpInside)
        view.addSubview(riverButton)
        
        forestButton.titleLabel?.font = UIFont(name: "ChelseaMarket-Regular", size: 30)
        forestButton.setTitle("Floresta", for: .normal)
        forestButton.setTitleColor(.black, for: .normal)
        forestButton.setTitleColor(.gray, for: .disabled)
        forestButton.isHidden = true
        forestButton.isEnabled = false
        //forestButton.addTarget(self, action: #selector(maeDaguaTransition), for: .touchUpInside)
        view.addSubview(forestButton)
        
        cityButton.titleLabel?.font = UIFont(name: "ChelseaMarket-Regular", size: 30)
        cityButton.setTitle("Cidade", for: .normal)
        cityButton.setTitleColor(.black, for: .normal)
        cityButton.setTitleColor(.gray, for: .disabled)
        cityButton.isHidden = true
        cityButton.isEnabled = false
        //cityButton.addTarget(self, action: #selector(maeDaguaTransition), for: .touchUpInside)
        view.addSubview(cityButton)
        
        sertaoButton.titleLabel?.font = UIFont(name: "ChelseaMarket-Regular", size: 30)
        sertaoButton.setTitle("Sertão", for: .normal)
        sertaoButton.setTitleColor(.black, for: .normal)
        sertaoButton.setTitleColor(.gray, for: .disabled)
        sertaoButton.isHidden = true
        sertaoButton.isEnabled = false
        //sertaoButton.addTarget(self, action: #selector(maeDaguaTransition), for: .touchUpInside)
        view.addSubview(sertaoButton)
        
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
        character.position = CGPoint(x: frame.minX, y: frame.minY + (character.size.height * 0.8))
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
        let moveBoard = SKAction.move(to: CGPoint(x: frame.midX, y: size.height * 0.3), duration: 0.5)
        let zoomBoard = SKAction.scale(to: 1.5, duration: 0.5)
        let boardAction = SKAction.sequence([moveBoard, zoomBoard])
        
        character.run(charDisappear){
            self.board.run(boardAction){
                self.makeYourChoice.isHidden = false
                self.sertaoButton.frame = CGRect(x: self.board.position.x, y: self.board.frame.midY, width: self.board.size.width * 0.5, height: 50)
                self.forestButton.frame = CGRect(x: self.board.position.x - self.board.size.width * 0.5 + 10, y: self.board.frame.midY + 50, width: self.board.size.width * 0.5, height: 50)
                self.cityButton.frame = CGRect(x: self.board.position.x, y: self.board.frame.midY + 118, width: self.board.size.width * 0.5, height: 50)
                self.riverButton.frame = CGRect(x: self.board.position.x - self.board.size.width * 0.45, y: self.board.frame.midY + 185, width: self.board.size.width * 0.5, height: 50)
                self.riverButton.isHidden = false
                self.forestButton.isHidden = false
                self.cityButton.isHidden = false
                self.sertaoButton.isHidden = false
            }
        }
    }
    
    @IBAction func maeDaguaTransition(){
        makeYourChoice.isHidden = true
        
        makeYourChoice.removeFromSuperview()
        riverButton.removeFromSuperview()
        forestButton.removeFromSuperview()
        cityButton.removeFromSuperview()
        sertaoButton.removeFromSuperview()
        
        let finalAction = SKAction.fadeOut(withDuration: 0.6)
        
        board.run(finalAction) {
            self.board.isHidden = true
        }
        
        sky.run(finalAction) {
            self.sky.isHidden = true
        }
        floor.run(finalAction){
            self.floor.isHidden = true
        }
        sun.run(finalAction){
            self.sun.isHidden = true
            //Chama a cena de escolha da Lenda
            self.view?.presentScene(MaeDaguaFirstScene(size: self.size))
        }
    }
    
}
