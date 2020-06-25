//
//  GameScene.swift
//  Lendario
//
//  Created by Fenda do Biquini on 25/06/20.
//  Copyright © 2020 Fenda do Biquini. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

//Tela Inicial
class MainScene: SKScene {
    //Imagens
    let logo = SKSpriteNode(imageNamed: "Logo")
    let background = SKSpriteNode(imageNamed: "Background")
    
    //Labels
    var lendarioName: SKLabelNode!
    var touchToBegin: SKLabelNode!
    
    override func didMove(to view: SKView) {
        //Define o ponto inicial como (0,0)
        self.anchorPoint = .zero
        
        //Configura a imagem de fundo
        background.size = size
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.zPosition = -1
        background.isHidden = false
        self.addChild(background)
        
        //Adiciona ação de pulsação dos elementos
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(by: -0.5, duration: 0.9),
            SKAction.fadeAlpha(by: 0.5, duration: 0.9),
        ])
        
        //Configura o logotipo
        logo.position = CGPoint(x: size.width * 0.5, y: size.height * 0.6)
        logo.zPosition = 1
        logo.isHidden = false
        //Adiciona o logo à cena
        self.addChild(logo)
        //Adicina ação de pulsação à logo (repete sempre)
        logo.run(SKAction.repeatForever(pulseAction))
        
        //Configura o nome Lendário
        lendarioName = SKLabelNode(fontNamed: "Xilosa")
        lendarioName.position = CGPoint(x: size.width * 0.5, y: size.height * 0.75)
        lendarioName.zPosition = 1
        lendarioName.fontSize = 36
        lendarioName.text = "Lendário"
        lendarioName.fontColor = .white
        self.addChild(lendarioName)
        
        lendarioName.run(SKAction.repeatForever(pulseAction))
        
        //Configura a frase
        touchToBegin = SKLabelNode(fontNamed: "ChelseaMarket-Regular")
        touchToBegin.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
        touchToBegin.zPosition = 1
        touchToBegin.fontSize = 20
        touchToBegin.text = "- Toque para começar -"
        touchToBegin.fontColor = .white
        self.addChild(touchToBegin)
        
        touchToBegin.run(SKAction.repeatForever(pulseAction))
    }
    
    //Função que identifica quando há toques na tela
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Move o nome para fora da cena e depois "esconde"
        lendarioName.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)){
            self.lendarioName.isHidden = true
        }
        
        //A logo diminui de tamanho
        logo.run(SKAction.scale(to: 0, duration: 0.3)){
            self.logo.isHidden = true
        }
        
        //Move a frase para fora da tela
        touchToBegin.run(SKAction.move(by: CGVector(dx: -50, dy: -100), duration: 0.5)){
            self.touchToBegin.isHidden = true
            //Chama a cena de apresentação
            self.view?.presentScene(OpenScene(size: self.size))
        }
    }
}
