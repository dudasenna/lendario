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
    private var fishman = SKSpriteNode()
    private var backgroundDayFloor = SKSpriteNode()
    private var backgroundDayRiver = SKSpriteNode()
    private var backgroundNightFloor = SKSpriteNode()
    private var backgroundNightRiver = SKSpriteNode()
    private var girlSpeechBubble = SKSpriteNode()
    private var fishmanSpeechBubble = SKSpriteNode()
    
    private var girlSpeechLine = SKLabelNode()
    private var fishmanSpeechLine = SKLabelNode()
    
    //Flags
    var secondSpeechFlag = 0
    var currentLine = 0
    
    //Som de Background
    var backgroundMusic: SKAudioNode!
    
    private var charWalkingFrames: [SKTexture] = []
    private var fishmanWalkingFrames: [SKTexture] = []
    
    private let cam = SKCameraNode()
    
    private var charVelocity: CGFloat = 0
    
    private var nextLineGirlButton = UIButton()
    private var nextLineFishmanButton = UIButton()
    private var interrogationButton = UIButton()
    
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
        //atribui a câmera
        self.camera = cam
        
        //Adiciona som de fundo
        if let musicURL = Bundle.main.url(forResource: "rio_passaros", withExtension: "wav") {
           backgroundMusic = SKAudioNode(url: musicURL)
           addChild(backgroundMusic)
        }
        
        //Posiciona a personagem principal na cena
        buildChar()
        
        self.scene?.isUserInteractionEnabled = false
        
        backgroundDayFloor = SKSpriteNode(imageNamed: "CenarioDia1")
        backgroundDayFloor.anchorPoint = .zero
        backgroundDayFloor.position = CGPoint(x: -frame.width/2, y: 0)
        backgroundDayFloor.zPosition = 0
        self.addChild(backgroundDayFloor)
        
        //Posiciona pescador na cena
        buildFishman(positionX: backgroundDayFloor.size.width)
        
        girlSpeechBubble = SKSpriteNode(imageNamed: "SpeechBubble")
        girlSpeechBubble.size = CGSize(width: frame.width * 0.3, height: frame.height * 0.3)
        girlSpeechBubble.position = CGPoint(x: character.position.x + girlSpeechBubble.size.width/2, y: frame.height * 0.8)
        girlSpeechBubble.zPosition = 1
        self.addChild(girlSpeechBubble)
        
        girlSpeechLine.text = "Nossa, onde será que eu estou, nesse lugar tão deserto?!"
        girlSpeechLine.preferredMaxLayoutWidth = girlSpeechBubble.size.width - 20
        girlSpeechLine.fontName = "ChelseaMarket-Regular"
        girlSpeechLine.fontSize = 15
        girlSpeechLine.fontColor = .black
        girlSpeechLine.numberOfLines = 3
        girlSpeechLine.horizontalAlignmentMode = .center
        girlSpeechLine.position = CGPoint(x: girlSpeechBubble.position.x, y: girlSpeechBubble.position.y * 0.98)
        girlSpeechLine.zPosition = 2
        currentLine = 1
        self.addChild(girlSpeechLine)
        
        fishmanSpeechBubble = SKSpriteNode(imageNamed: "SpeechBubble")
        fishmanSpeechBubble.size = CGSize(width: frame.width * 0.25, height: frame.height * 0.3)
        fishmanSpeechBubble.position = CGPoint(x: fishman.position.x + fishmanSpeechBubble.size.width/2 + 20, y: frame.height * 0.79)
        fishmanSpeechBubble.zPosition = 1
        fishmanSpeechBubble.isHidden = true
        self.addChild(fishmanSpeechBubble)
        
        fishmanSpeechLine.text = "Opa, tá tudo bem com você? Parece que viu uma assombração…"
        fishmanSpeechLine.preferredMaxLayoutWidth = fishmanSpeechBubble.size.width - 20
        fishmanSpeechLine.fontName = "ChelseaMarket-Regular"
        fishmanSpeechLine.fontSize = 15
        fishmanSpeechLine.fontColor = .black
        fishmanSpeechLine.numberOfLines = 3
        fishmanSpeechLine.horizontalAlignmentMode = .center
        fishmanSpeechLine.position = CGPoint(x: fishmanSpeechBubble.position.x, y: fishmanSpeechBubble.position.y * 0.98)
        fishmanSpeechLine.zPosition = 2
        fishmanSpeechLine.isHidden = true
        self.addChild(fishmanSpeechLine)
        
        nextLineGirlButton.setImage(UIImage(named: "NextSign"), for: .normal)
        nextLineGirlButton.frame = CGRect(x: frame.midX + girlSpeechBubble.size.width - 30, y: size.height * 0.19, width: 20, height: 22)
        nextLineGirlButton.addTarget(self, action: #selector(firstSpeech), for: .touchUpInside)
        view.addSubview(nextLineGirlButton)
        
        interrogationButton.setImage(UIImage(named: "interrogation"), for: .normal)
        interrogationButton.frame = CGRect(x: size.width/2 + character.size.width - 20, y: size.height * 0.19, width: 100, height: 100)
        interrogationButton.addTarget(self, action: #selector(fishmanDialogue), for: .touchUpInside)
        interrogationButton.isHidden = true
        view.addSubview(interrogationButton)
        
        nextLineFishmanButton.setImage(UIImage(named: "NextSign"), for: .normal)
        nextLineFishmanButton.frame = CGRect(x: frame.midX + fishmanSpeechBubble.size.width * 1.3 , y: size.height * 0.2, width: 20, height: 22)
        nextLineFishmanButton.addTarget(self, action: #selector(secondSpeech), for: .touchUpInside)
        nextLineFishmanButton.isHidden = true
        view.addSubview(nextLineFishmanButton)
        
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
        if (offset < 0) || (character.position.x >= fishman.position.x - character.size.width - 20){
            charVelocity = 0
        }
        
        if (character.position.x >= fishman.position.x - character.size.width - 20) && secondSpeechFlag == 0{
            prepareForFishman()
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
        if character.position.x > 0 || location.x > character.position.x{
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
        
        character = SKSpriteNode(imageNamed: "female_walk0")
        character.position = CGPoint(x: frame.minX, y: frame.midY)
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
    
    private func buildFishman(positionX : CGFloat) {
        let fishmanAnimatedAtlas = SKTextureAtlas(named: "Fishman")
        var walkFrames: [SKTexture] = []
        
        let numImages = fishmanAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let fishmanTextureName = "female_walk\(i)"
            walkFrames.append(fishmanAnimatedAtlas.textureNamed(fishmanTextureName))
        }
        
        fishmanWalkingFrames = walkFrames
        
        fishman = SKSpriteNode(imageNamed: "fishman0")
        fishman.position = CGPoint(x: positionX/3, y: frame.midY)
        fishman.xScale = fishman.xScale * (-1)
        fishman.size = CGSize(width: frame.width * 0.07, height: frame.height * 0.3)
        fishman.zPosition = 1
        
        self.addChild(fishman)
        
    }
    
    private func prepareForFishman(){
        interrogationButton.isHidden = false
        secondSpeechFlag = 1
        character.isPaused = true
        self.scene?.isUserInteractionEnabled = false
    }
    
    @IBAction private func firstSpeech(){
        if currentLine == 1{
            girlSpeechLine.run(SKAction.fadeOut(withDuration: 0.3)){
                self.girlSpeechLine.position.y = self.girlSpeechLine.position.y - 10
                self.girlSpeechLine.text = "Eu apenas tentei começar um jogo e acordei na beira desse rio…"
                self.girlSpeechLine.run(SKAction.fadeIn(withDuration: 0.3))
            }
            currentLine = 2
        } else if currentLine == 2{
            girlSpeechLine.run(SKAction.fadeOut(withDuration: 0.3)){
                self.girlSpeechLine.text = "Acho que é melhor eu começar a andar e procurar alguém que me explique onde estou."
                self.girlSpeechLine.run(SKAction.fadeIn(withDuration: 0.3))
            }
            currentLine = 3
        } else if currentLine == 3{
            girlSpeechLine.run(SKAction.fadeOut(withDuration: 0.3)){
                self.girlSpeechLine.isHidden = true
            }
            girlSpeechBubble.run(SKAction.fadeOut(withDuration: 0.3)){
                self.girlSpeechBubble.isHidden = true
                self.nextLineGirlButton.isHidden = true
                self.scene?.isUserInteractionEnabled = true
            }
            nextLineGirlButton.removeTarget(self, action: #selector(firstSpeech), for: .touchUpInside)
            nextLineGirlButton.addTarget(self, action: #selector(secondSpeechGirl), for: .touchUpInside)
            currentLine = 0
        }
        
    }
    
    @IBAction private func fishmanDialogue(){
        fishmanSpeechBubble.isHidden = false
        fishmanSpeechLine.isHidden = false
        nextLineFishmanButton.isHidden = false
        interrogationButton.isHidden = true
    }
    
    @IBAction private func secondSpeech(){
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        if currentLine == 0 {
            girlSpeechBubble.xScale = girlSpeechBubble.xScale * (-1)
            girlSpeechBubble.position = CGPoint(x: character.position.x - girlSpeechBubble.size.width/2 - 20, y: frame.height * 0.8)
            girlSpeechLine.text = "Eu não sei que lugar é esse, eu apenas acordei na beira desse rio que nunca vi."
            girlSpeechLine.position = CGPoint(x: girlSpeechBubble.position.x, y: girlSpeechBubble.position.y * 0.98)
            nextLineGirlButton.frame = CGRect(x: frame.midX - character.size.width, y: size.height * 0.22, width: 20, height: 22)
            
            nextLineFishmanButton.isHidden = true
            fishmanSpeechLine.run(fadeOutAction)
            fishmanSpeechBubble.run(fadeOutAction){
                self.fishmanSpeechBubble.isHidden = true
                self.girlSpeechLine.isHidden = false
                self.girlSpeechLine.run(fadeInAction)
                self.girlSpeechBubble.isHidden = false
                self.girlSpeechBubble.run(fadeInAction)
                self.nextLineGirlButton.isHidden = false
            }
            
            currentLine = 1
            
        } else if currentLine == 2{
            fishmanSpeechLine.run(SKAction.fadeOut(withDuration: 0.3)){
                //self.fishmanSpeechLine.position.y = self.girlSpeechLine.position.y - 10
                self.fishmanSpeechLine.text = "Meu nome é João, e esse é o Rio São Francisco."
                self.fishmanSpeechLine.run(fadeInAction)
            }
            
            currentLine = 3
            
        } else if currentLine == 3{
            girlSpeechLine.text = "O meu é Tina, você conhece esse lugar?? Pode me ajudar??"
            girlSpeechLine.position.y = girlSpeechLine.position.y + 10
            
            nextLineFishmanButton.isHidden = true
            fishmanSpeechLine.run(fadeOutAction)
            fishmanSpeechBubble.run(fadeOutAction){
                self.fishmanSpeechBubble.isHidden = true
                self.girlSpeechLine.isHidden = false
                self.girlSpeechLine.run(fadeInAction)
                self.girlSpeechBubble.isHidden = false
                self.girlSpeechBubble.run(fadeInAction)
                self.nextLineGirlButton.isHidden = false
            }
            
            currentLine = 4
            
        } else if currentLine == 5{
            girlSpeechLine.text = "Fala dele como se fosse uma pessoa?"
            
            nextLineFishmanButton.isHidden = true
            fishmanSpeechLine.run(fadeOutAction)
            fishmanSpeechBubble.run(fadeOutAction){
                self.fishmanSpeechBubble.isHidden = true
                self.girlSpeechLine.isHidden = false
                self.girlSpeechLine.run(fadeInAction)
                self.girlSpeechBubble.isHidden = false
                self.girlSpeechBubble.run(fadeInAction)
                self.nextLineGirlButton.isHidden = false
            }
            
            currentLine = 6
            
        } else if currentLine == 7{
            fishmanSpeechLine.run(SKAction.fadeOut(withDuration: 0.3)){
                //self.fishmanSpeechLine.position.y = self.girlSpeechLine.position.y - 10
                self.fishmanSpeechLine.text = "E foi assim também pra meus pais e meus avós antes deles."
                self.fishmanSpeechLine.run(fadeInAction)
            }
            
            currentLine = 8
            
        } else if currentLine == 8{
            fishmanSpeechLine.run(SKAction.fadeOut(withDuration: 0.3)){
                //self.fishmanSpeechLine.position.y = self.girlSpeechLine.position.y - 10
                self.fishmanSpeechLine.text = "Em cada um de nós vive um pouco dele..."
                self.fishmanSpeechLine.run(fadeInAction)
            }
            
            currentLine = 9
            
        } else if currentLine == 9{
            fishmanSpeechLine.run(SKAction.fadeOut(withDuration: 0.3)){
                //self.fishmanSpeechLine.position.y = self.girlSpeechLine.position.y - 10
                self.fishmanSpeechLine.text = "Assim como nele vive um pouquinho da gente..."
                self.fishmanSpeechLine.run(fadeInAction)
            }
            
            currentLine = 10
            
        } else if currentLine == 10{
            fishmanSpeechLine.run(SKAction.fadeOut(withDuration: 0.3)){
                //self.fishmanSpeechLine.position.y = self.girlSpeechLine.position.y - 10
                self.fishmanSpeechLine.text = "E algumas outras coisas mais…"
                self.fishmanSpeechLine.run(fadeInAction)
            }
            
            currentLine = 11
            
        } else if currentLine == 11{
            //girlSpeechLine.position.y = girlSpeechLine.position.y + 10
            girlSpeechLine.text = "Outras coisas?"
            
            nextLineFishmanButton.isHidden = true
            fishmanSpeechLine.run(fadeOutAction)
            fishmanSpeechBubble.run(fadeOutAction){
                self.fishmanSpeechBubble.isHidden = true
                self.girlSpeechLine.isHidden = false
                self.girlSpeechLine.run(fadeInAction)
                self.girlSpeechBubble.isHidden = false
                self.girlSpeechBubble.run(fadeInAction)
                self.nextLineGirlButton.isHidden = false
            }
            
            currentLine = 12
            
        } else if currentLine == 13{
            fishmanSpeechLine.run(SKAction.fadeOut(withDuration: 0.3)){
                //self.fishmanSpeechLine.position.y = self.girlSpeechLine.position.y - 10
                self.fishmanSpeechLine.text = "Eu vou indo antes que fique muito tarde..."
                self.fishmanSpeechLine.run(fadeInAction)
            }
            
            currentLine = 14
            
        } else if currentLine == 14{
            fishmanSpeechLine.run(SKAction.fadeOut(withDuration: 0.3)){
                self.fishmanSpeechLine.position.y = self.fishmanSpeechLine.position.y + 10
                self.fishmanSpeechLine.text = "Tem um lugar no meu barco pra você se quiser."
                self.fishmanSpeechLine.run(fadeInAction)
            }
            
            currentLine = 15
            
        } else if currentLine == 15{
            girlSpeechLine.text = "Ah! Eu quero sim, e no caminho você pode me falar sobre essas outras coisas?"
            girlSpeechLine.position.y = girlSpeechLine.position.y - 10
            
            nextLineFishmanButton.isHidden = true
            fishmanSpeechLine.run(fadeOutAction)
            fishmanSpeechBubble.run(fadeOutAction){
                self.fishmanSpeechBubble.isHidden = true
                self.girlSpeechLine.isHidden = false
                self.girlSpeechLine.run(fadeInAction)
                self.girlSpeechBubble.isHidden = false
                self.girlSpeechBubble.run(fadeInAction)
                self.nextLineGirlButton.isHidden = false
            }
            
            currentLine = 16
            
        } else if currentLine == 17{
            nextLineFishmanButton.isHidden = true
            nextLineGirlButton.isHidden = true
            
            girlSpeechLine.run(fadeOutAction){
                self.girlSpeechLine.isHidden = true
                self.girlSpeechBubble.run(fadeOutAction)
                self.girlSpeechBubble.isHidden = true
            }
            
            fishmanSpeechLine.run(fadeOutAction){
                self.fishmanSpeechLine.isHidden = true
                self.fishmanSpeechBubble.run(fadeOutAction)
                self.fishmanSpeechBubble.isHidden = true
                self.finishScene()
            }
        }
    }
    
    @IBAction private func secondSpeechGirl(){
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        
        if currentLine == 1{
            fishmanSpeechLine.text = "Tá aí algo que num se ouve todo dia."
            
            nextLineGirlButton.isHidden = true
            girlSpeechLine.run(fadeOutAction)
            girlSpeechBubble.run(fadeOutAction){
                self.girlSpeechBubble.isHidden = true
                self.fishmanSpeechLine.isHidden = false
                self.fishmanSpeechLine.run(fadeInAction)
                self.fishmanSpeechBubble.isHidden = false
                self.fishmanSpeechBubble.run(fadeInAction)
                self.nextLineFishmanButton.isHidden = false
            }
            
            currentLine = 2
        } else if currentLine == 4{
            fishmanSpeechLine.text = "Conheço bastante e o velho Chico é meu amigo de infância."
            
            nextLineGirlButton.isHidden = true
            girlSpeechLine.run(fadeOutAction)
            girlSpeechBubble.run(fadeOutAction){
                self.girlSpeechBubble.isHidden = true
                self.fishmanSpeechLine.isHidden = false
                self.fishmanSpeechLine.run(fadeInAction)
                self.fishmanSpeechBubble.isHidden = false
                self.fishmanSpeechBubble.run(fadeInAction)
                self.nextLineFishmanButton.isHidden = false
            }
            
            currentLine = 5
            
        } else if currentLine == 6{
            fishmanSpeechLine.text = "Compartilho minha vida com essas águas há muito tempo..."
            
            nextLineGirlButton.isHidden = true
            girlSpeechLine.run(fadeOutAction)
            girlSpeechBubble.run(fadeOutAction){
                self.girlSpeechBubble.isHidden = true
                self.fishmanSpeechLine.isHidden = false
                self.fishmanSpeechLine.run(fadeInAction)
                self.fishmanSpeechBubble.isHidden = false
                self.fishmanSpeechBubble.run(fadeInAction)
                self.nextLineFishmanButton.isHidden = false
            }
            
            currentLine = 7
            
        } else if currentLine == 12{
            fishmanSpeechLine.text = "Sim, mas já tá escurecendo, num é hora pra isso não..."
            
            nextLineGirlButton.isHidden = true
            girlSpeechLine.run(fadeOutAction)
            girlSpeechBubble.run(fadeOutAction){
                self.girlSpeechBubble.isHidden = true
                self.fishmanSpeechLine.isHidden = false
                self.fishmanSpeechLine.run(fadeInAction)
                self.fishmanSpeechBubble.isHidden = false
                self.fishmanSpeechBubble.run(fadeInAction)
                self.nextLineFishmanButton.isHidden = false
            }
            
            currentLine = 13
            
        } else if currentLine == 16{
            fishmanSpeechLine.text = "Tá certo! Vamos subir no meu barco e seguir nosso rumo, porque daqui a pouco escurece."
            fishmanSpeechLine.position.y = fishmanSpeechLine.position.y - 30
            
            nextLineGirlButton.isHidden = true
            girlSpeechLine.run(fadeOutAction)
            girlSpeechBubble.run(fadeOutAction){
                self.girlSpeechBubble.isHidden = true
                self.fishmanSpeechLine.isHidden = false
                self.fishmanSpeechLine.run(fadeInAction)
                self.fishmanSpeechBubble.isHidden = false
                self.fishmanSpeechBubble.run(fadeInAction)
                self.nextLineFishmanButton.isHidden = false
            }
            
            currentLine = 17
            
        }
    }
    
    private func finishScene(){
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        
        nextLineGirlButton.removeFromSuperview()
        nextLineFishmanButton.removeFromSuperview()
        interrogationButton.removeFromSuperview()
        
        character.isPaused = true
        self.scene?.isUserInteractionEnabled = false
        
        character.run(fadeOut)
        fishman.run(fadeOut){
            self.backgroundDayFloor.run(fadeOut){
                self.view?.presentScene(MaeDaguaSecondScene(size: self.size))
            }
        }
    }
}
