//
//  MaeDaguaSecondScene.swift
//  Lendario
//
//  Created by Fenda do Biquini on 01/07/20.
//  Copyright © 2020 Fenda do Biquini. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class MaeDaguaSecondScene: SKScene {
       private var character = SKSpriteNode()
       private var fishman = SKSpriteNode()
       private var backgroundDayFloor = SKSpriteNode()
       private var backgroundDayRiver = SKSpriteNode()
       private var backgroundNightFloor = SKSpriteNode()
       private var backgroundNightRiver = SKSpriteNode()
       private var boat = SKSpriteNode()
       private var boatChar = SKSpriteNode()
    private var sign = SKSpriteNode()
       
       private var charWalkingFrames: [SKTexture] = []
       private var fishmanWalkingFrames: [SKTexture] = []
       
       private let cam = SKCameraNode()
       
       private var charVelocity: CGFloat = 0
    
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        
        //atribui a câmera
        self.camera = cam
        
        //Posiciona a personagem principal na cena
        buildChar()
        buildFishman()
        
        //Posiciona pescador na cena
        //buildFishman()
        
        backgroundDayFloor = SKSpriteNode(imageNamed: "CenarioDia1")
        backgroundDayFloor.anchorPoint = .zero
        backgroundDayFloor.position = CGPoint(x: -frame.width/2, y: 0)
        backgroundDayFloor.zPosition = 0
        backgroundDayFloor.isHidden = true
        self.addChild(backgroundDayFloor)
        
        //background setup
        backgroundDayRiver = SKSpriteNode(imageNamed: "CenarioDia2")
        backgroundDayRiver.anchorPoint = .zero
        backgroundDayRiver.position = CGPoint(x: -frame.width/2, y: 0)
        backgroundDayRiver.zPosition = 0
      //  backgroundDayRiver.isHidden = true
        self.addChild(backgroundDayRiver)
        
        //background setup
        backgroundNightFloor = SKSpriteNode(imageNamed: "CenarioNoite2")
        backgroundNightFloor.anchorPoint = .zero
        backgroundNightFloor.position = CGPoint(x: -frame.width/2, y: 0)
        backgroundNightFloor.zPosition = 0
        backgroundNightFloor.isHidden = true
        self.addChild(backgroundNightFloor)
        
        backgroundNightRiver = SKSpriteNode(imageNamed: "CenarioNoite1")
        backgroundNightRiver.anchorPoint = .zero
        backgroundNightRiver.position = CGPoint(x: -frame.width/2, y: 0)
        backgroundNightRiver.zPosition = 0
        backgroundNightRiver.isHidden = true
        self.addChild(backgroundNightRiver)
        
        boat = SKSpriteNode(imageNamed: "barco")
        boat.anchorPoint = .zero
        boat.size = CGSize(width: 328, height: 121)
        boat.position = CGPoint(x: frame.width/3, y: 40)
        boat.zPosition = 1
        boat.name = "boat"
        boat.isUserInteractionEnabled = false
        self.addChild(boat)
        
        sign = SKSpriteNode(imageNamed: "seta")
        sign.anchorPoint = .zero
        sign.position = CGPoint(x: 1.5*frame.width/3, y: boat.size.height+40)
        sign.zPosition = 2
        self.addChild(sign)
        
        let pulseAction = SKAction.sequence([
                 SKAction.fadeAlpha(by: -0.5, duration: 0.9),
                 SKAction.fadeAlpha(by: 0.5, duration: 0.9),
             ])
        sign.run(SKAction.repeatForever(pulseAction))
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Se a próxima posição da personagem for menor do que a inicial (0,0), então ela não anda
        let offset = character.physicsBody!.velocity.dx + character.position.x
        
        //offset menor que zero ou maior ou igual a posição do pescador - 40, para
        if (offset < 0)  {
            charVelocity = 0
        }
        
        //Define a velocidade da personagem (andando pra frente - 200 -, pra trás - -200 - ou parada)
        character.physicsBody?.velocity.dx = charVelocity
        fishman.physicsBody?.velocity.dx = charVelocity
    }
    
    //Coloca a câmera para "seguir a personagem pela cena"
    override func didSimulatePhysics() {
        self.camera!.position = character.position
    }
    
    //Chamada quando um toque na tela é identificado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Salva localização do primeiro toque
        let touch = touches.first!
        let location = touch.location(in: self)
        
        let touchedNode = self.atPoint(location)
        //verifica se tocou no barco
        if let name = touchedNode.name
        {
            if name == "boat"
            {
                print("Touched")
            }
        }
        
        
        //A personagem só se movimenta pra ambos os lados se sua posição for maior do que a inicial, se for menor, ela só pode ir para frente
        if character.position.x > 0 || location.x > character.position.x{
            var multiplierForDirection: CGFloat
            
            character.isPaused = false
            fishman.isPaused = false
            animateChar()
            animateFishman()
            
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
            fishman.xScale = abs(fishman.xScale) * multiplierForDirection
        }
    }
    
    //Ao retirar o dedo da tela, o movimento para
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        charVelocity = 0
        charMoveEnded()
        fishmanMoveEnded()
    }
    
    private func buildChar() {
        let charAnimatedAtlas = SKTextureAtlas(named: "character")
        var walkFrames: [SKTexture] = []
        let offset = frame.midY + 10
        
        let numImages = charAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let charTextureName = "female_walk\(i)"
            walkFrames.append(charAnimatedAtlas.textureNamed(charTextureName))
        }
        
        charWalkingFrames = walkFrames
        
        character = SKSpriteNode(imageNamed: "female_walk0")
        character.position = CGPoint(x: frame.minX, y: offset)
        character.size = CGSize(width: frame.width * 0.07, height: frame.height * 0.3)
        character.zPosition = 1
        
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.affectedByGravity = false
        
        self.addChild(character)
        
    }
    
    private func animateChar() {
        let walkAction = SKAction.animate(with: charWalkingFrames, timePerFrame: 0.25)
        let charAction = SKAction.repeatForever(walkAction)
        character.run(charAction)
    }
    
    private func charMoveEnded() {
        character.isPaused = true
    }
    
    private func buildFishman() {
        let fishmanAnimatedAtlas = SKTextureAtlas(named: "Fishman")
        var walkFrames: [SKTexture] = []
        let offset = frame.midY + 10

        
        let numImages = fishmanAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let fishmanTextureName = "fishman\(i)"
            walkFrames.append(fishmanAnimatedAtlas.textureNamed(fishmanTextureName))
        }
        
        fishmanWalkingFrames = walkFrames
        
        fishman = SKSpriteNode(imageNamed: "fishman0")
        fishman.position = CGPoint(x: frame.minX - character.frame.width - 20, y: offset)
        fishman.size = CGSize(width: frame.width * 0.07, height: frame.height * 0.3)
        fishman.zPosition = 1
        fishman.physicsBody = SKPhysicsBody(rectangleOf: fishman.size)
        fishman.physicsBody?.affectedByGravity = false
        
        self.addChild(fishman)
        
    }
    
    private func animateFishman() {
           let walkAction = SKAction.animate(with: fishmanWalkingFrames, timePerFrame: 0.25)
           let charAction = SKAction.repeatForever(walkAction)
           fishman.run(charAction)
       }
       
       private func fishmanMoveEnded() {
           fishman.isPaused = true
       }
    
}

