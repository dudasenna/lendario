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


class MaeDaguaFirstScene: SKScene {
    private var character = SKSpriteNode()
    var backgroundDayFloor = SKSpriteNode()
    var backgroundDayRiver = SKSpriteNode()
    var backgroundNightFloor = SKSpriteNode()
    var backgroundNightRiver = SKSpriteNode()
    
    private var charWalkingFrames: [SKTexture] = []
    
    let cam = SKCameraNode()
    
    var charVelocity: CGFloat = 0
    
    var inicialPos: CGPoint!
    var livePos: CGPoint!
    
//    class ViewController: UIViewController {
//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//            let pauseButton = UIButton(frame: CGRect(x: 360, y: 150, width: 200, height: 50))
//            pauseButton.backgroundColor = .red
//            pauseButton.addTarget(self, action: #selector(pauseButtonAction), for: .touchUpInside)
//
//            self.view.addSubview(pauseButton)
//        }
//
//        @objc func pauseButtonAction (sender: UIButton!) {
//            print("Pause button tapped")
//        }
//
//    }
    
    let redColor = UIColor(red: 141/255, green: 46/255, blue: 33/255, alpha: 1)
    
    let configButton = UIButton()
    let configLabel = UILabel()
    let soundConfigLabel = UILabel()
    let musicConfigLabel = UILabel()
    let connectedLabel = UILabel()
    let backTextButton = UIButton()
    let backIconButton = UIButton()
    let pauseButton = UIButton()
    let blurSubview = UIButton()
    let popupSubview = UIView()
    let continueButton = UIButton()
    let beginButton = UIButton()
    let soundPauseLabel = UILabel()
    let musicPauseLabel = UILabel()
    let pauseIcon = UIImage(named: "pauseIcon.png")
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        print(size)
        //atribui a câmera
        self.camera = cam
        
        //Posiciona a personagem principal na c3ena
        buildChar()
        
        backgroundDayFloor = SKSpriteNode(imageNamed: "CenarioDia1")
        backgroundDayFloor.anchorPoint = .zero
        backgroundDayFloor.position = CGPoint(x: -frame.width/2, y: 0)
        backgroundDayFloor.zPosition = 0
        self.addChild(backgroundDayFloor)
        
        //background setup
        backgroundDayRiver = SKSpriteNode(imageNamed: "CenarioDia2")
        backgroundDayRiver.anchorPoint = .zero
        backgroundDayRiver.position = CGPoint(x: -frame.width/2, y: 0)
        backgroundDayRiver.zPosition = 0
        backgroundDayRiver.isHidden = true
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
        
        blurSubview.frame = view.bounds
        blurSubview.backgroundColor = UIColor(white: 1, alpha: 0.7)
        blurSubview.addTarget(self, action: #selector(continueButtonAction), for: .touchUpInside)
        blurSubview.isHidden = true
        view.addSubview(blurSubview)
        
        configButton.frame = CGRect(x: 100, y: 35, width: 50, height: 50)
//        configButton.setImage(configIcon, for: .normal)
        configButton.backgroundColor = .blue
//        pauseButton.contentMode = .center
//        configButton.imageView?.contentMode = .scaleAspectFill
//        pauseButton.imageEdgeInsets = UIEdgeInsets(top: 25,left: 25,bottom: 25,right: 25)
        configButton.addTarget(self, action: #selector(configButtonAction), for: .touchUpInside)
        view.addSubview(configButton)
        
        configLabel.frame = CGRect(x: 80, y: 40, width: 300, height: 50)
        configLabel.text = "Configurações"
        configLabel.textColor = redColor
        configLabel.textAlignment = .left
        configLabel.font = UIFont(name: "ChelseaMarket-Regular", size: 40)
        configLabel.isHidden = true
        view.addSubview(configLabel)
        
        soundConfigLabel.frame = CGRect(x: 270, y: 130, width: 200, height: 50)
        soundConfigLabel.text = "Som:"
        soundConfigLabel.textColor = .black
        soundConfigLabel.textAlignment = .left
        soundConfigLabel.font = UIFont(name: "ChelseaMarket-Regular", size: 25)
        soundConfigLabel.isHidden = true
        view.addSubview(soundConfigLabel)
        
        musicConfigLabel.frame = CGRect(x: 270, y: 180, width: 200, height: 50)
        musicConfigLabel.text = "Música:"
        musicConfigLabel.textColor = .black
        musicConfigLabel.textAlignment = .left
        musicConfigLabel.font = UIFont(name: "ChelseaMarket-Regular", size: 25)
        musicConfigLabel.isHidden = true
        view.addSubview(musicConfigLabel)
        
        connectedLabel.frame = CGRect(x: 270, y: 230, width: 300, height: 50)
        connectedLabel.text = "Conectado como:"
        connectedLabel.textColor = .black
        connectedLabel.textAlignment = .left
        connectedLabel.font = UIFont(name: "ChelseaMarket-Regular", size: 25)
        connectedLabel.isHidden = true
        view.addSubview(connectedLabel)
        
        backTextButton.frame = CGRect(x: 650, y: 300, width: 200, height: 50)
        backTextButton.setTitle("Voltar", for: .normal)
        backTextButton.setTitleColor(redColor, for: .normal)
        backTextButton.titleLabel?.font = UIFont(name: "ChelseaMarket-Regular", size: 15)
        backTextButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backTextButton.isHidden = true
        view.addSubview(backTextButton)
        
        backIconButton.frame = CGRect(x: 685, y: 300, width: 200, height: 50)
        backIconButton.setTitle(">", for: .normal) //substituir por icon
        backIconButton.setTitleColor(redColor, for: .normal)
        backIconButton.titleLabel?.font = UIFont(name: "ChelseaMarket-Regular", size: 30)
        backIconButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backIconButton.isHidden = true
        view.addSubview(backIconButton)
        
        pauseButton.frame = CGRect(x: 800, y: 35, width: 50, height: 50)
        pauseButton.setImage(pauseIcon, for: .normal)
        pauseButton.backgroundColor = .blue
//        pauseButton.contentMode = .center
        pauseButton.imageView?.contentMode = .scaleAspectFill
//        pauseButton.imageEdgeInsets = UIEdgeInsets(top: 25,left: 25,bottom: 25,right: 25)
        pauseButton.addTarget(self, action: #selector(pauseButtonAction), for: .touchUpInside)
        view.addSubview(pauseButton)
        
        popupSubview.frame = CGRect(x: 235, y: 90, width: 450, height: 220)
        popupSubview.backgroundColor = .white
        popupSubview.layer.cornerRadius = 40
        popupSubview.isHidden = true
        view.addSubview(popupSubview)
        
        continueButton.frame = CGRect(x: 360, y: 110, width: 200, height: 50)
        continueButton.setTitle("Continuar", for: .normal)
        continueButton.setTitleColor(.black, for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "ChelseaMarket-Regular", size: 28)
        continueButton.addTarget(self, action: #selector(continueButtonAction), for: .touchUpInside)
        continueButton.isHidden = true
        view.addSubview(continueButton)
        
        beginButton.frame = CGRect(x: 330, y: 155, width: 200, height: 50)
        beginButton.setTitle("Início", for: .normal)
        beginButton.setTitleColor(.black, for: .normal)
        beginButton.titleLabel?.font = UIFont(name: "ChelseaMarket-Regular", size: 28)
        beginButton.addTarget(self, action: #selector(beginButtonAction), for: .touchUpInside)
        beginButton.isHidden = true
        view.addSubview(beginButton)
        
        soundPauseLabel.frame = CGRect(x: 390, y: 200, width: 200, height: 50)
        soundPauseLabel.text = "Som:"
        soundPauseLabel.textColor = .black
        soundPauseLabel.textAlignment = .left
        soundPauseLabel.font = UIFont(name: "ChelseaMarket-Regular", size: 28)
        soundPauseLabel.isHidden = true
        view.addSubview(soundPauseLabel)
        
        musicPauseLabel.frame = CGRect(x: 390, y: 245, width: 200, height: 50)
        musicPauseLabel.text = "Música:"
        musicPauseLabel.textColor = .black
        musicPauseLabel.textAlignment = .left
        musicPauseLabel.font = UIFont(name: "ChelseaMarket-Regular", size: 28)
        musicPauseLabel.isHidden = true
        view.addSubview(musicPauseLabel)
        
    }
    
    @objc func configButtonAction (sender: UIButton!) {
        print("Pause button tapped")
        configButton.isHidden = true
        pauseButton.isHidden = true
        blurSubview.isHidden = false
        configLabel.isHidden = false
        soundConfigLabel.isHidden = false
        musicConfigLabel.isHidden = false
        connectedLabel.isHidden = false
        backTextButton.isHidden = false
        backIconButton.isHidden = false
    }
    
    @objc func backButtonAction (sender: UIButton!) {
        print("Pause button tapped")
        configButton.isHidden = false
        pauseButton.isHidden = false
        blurSubview.isHidden = true
        configLabel.isHidden = true
        soundConfigLabel.isHidden = true
        musicConfigLabel.isHidden = true
        connectedLabel.isHidden = true
        backTextButton.isHidden = true
        backIconButton.isHidden = true
    }
    
    @objc func pauseButtonAction (sender: UIButton!) {
        print("Pause button tapped")
        configButton.isHidden = true
        pauseButton.isHidden = true
        blurSubview.isHidden = false
        popupSubview.isHidden = false
        continueButton.isHidden = false
        beginButton.isHidden = false
        soundPauseLabel.isHidden = false
        musicPauseLabel.isHidden = false
    }
    
    @objc func continueButtonAction (sender: UIButton!) {
        print("Continue button tapped")
        configButton.isHidden = false
        pauseButton.isHidden = false
        blurSubview.isHidden = true
        popupSubview.isHidden = true
        continueButton.isHidden = true
        beginButton.isHidden = true
        soundPauseLabel.isHidden = true
        musicPauseLabel.isHidden = true
        configLabel.isHidden = true
        soundConfigLabel.isHidden = true
        musicConfigLabel.isHidden = true
        connectedLabel.isHidden = true
        backTextButton.isHidden = true
        backIconButton.isHidden = true
    }
    
    @objc func beginButtonAction (sender: UIButton!) {
        print("New game button tapped")
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
        
        //A personagem só se movimenta pra ambos os lados se sua posição for maior do que a inicial, se for menor, ela só pode ir para frente
        if character.position.x > inicialPos.x || location.x > character.position.x{
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
    }
    
    //Ao retirar o dedo da tela, o movimento para
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
        
        character.position = CGPoint(x: frame.minX, y: frame.midY)
        character.zPosition = 1
        inicialPos = character.position
        
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.affectedByGravity = false
        
        self.addChild(character)
        
    }
    
    private func animateChar() {
        let walkAction = SKAction.animate(with: charWalkingFrames, timePerFrame: 0.3)
        let charAction = SKAction.repeatForever(walkAction)
        character.run(charAction)
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

