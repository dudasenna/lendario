//
//  OpenScene.swift
//  Lendario
//
//  Created by Fenda do Biquini on 25/06/20.
//  Copyright © 2020 Fenda do Biquini. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class OpenScene: SKScene {
    //Imagens
    let sky = SKSpriteNode(imageNamed: "Céu")
    let floor = SKSpriteNode(imageNamed: "Chão")
    let sun = SKSpriteNode(imageNamed: "Sol")
    
    //Frases
    var firstPhrase: String!
    var secondPhrase: String!
    var thirdPhrase: String!
    var fourthPhrase: String!
    var fifthPhrase: String!
    
    //Flag usada para identificar o toque na última tela da pageControl (gambiarra)
    var lastPageFlag: Int!
    
    //Label que recebe os textos da apresentação
    var presentationText = UILabel()
    
    //Permite a mudança entre páginas ("bolinhas")
    let pageControl = UIPageControl()
    
    //Botão de pular a tela de apresentação
    let skipButton = UIButton()
    
    override func didMove(to view: SKView){
        self.anchorPoint = .zero
        
        pageControl.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        
        //Aumenta a altura da tela, para que o toque seja reconhecido na tela toda
        pageControl.layer.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 2)
        //Muda a posição das bolinhas pra parte inferior da tela (inicialmente eles ficam no meio)
        pageControl.layer.position.y = view.frame.height - 50
        view.addSubview(pageControl)
        
        //Configura o chão
        floor.size = size
        floor.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        floor.zPosition = -1
        self.addChild(floor)
        
        //Configura o céu
        sky.position = CGPoint(x: floor.position.x, y: floor.position.y + 210)
        sky.size.width = size.width
        sky.zPosition = -3
        self.addChild(sky)
        
        //Configura o sol
        sun.size = CGSize(width: sun.size.width * 1.5, height: sun.size.height * 1.5)
        sun.position = CGPoint(x: size.width * 0.9, y: floor.position.y)
        sun.zPosition = -2
        self.addChild(sun)
        
        //Define as frases
        firstPhrase = "Olá! Aqui começa uma pequena jornada pelo folclore nordestino..."
        
        secondPhrase = "...Através de interações com o ambiente, você irá descobrir mais sobre as lendas da nossa região..."
        
        thirdPhrase = "...Você poderá descobrir lendas de acordo com o ambiente que preferir explorar!"
        
        fourthPhrase = "Para uma melhor experiência utilize fones de ouvido!!"
        
        fifthPhrase = "Vamos lá!"
        
        //Configura a label
        presentationText.frame = CGRect(x: size.width * 0.3, y: size.height * 0.3, width: size.width * 0.4, height:  size.height * 0.4)
        presentationText.font = UIFont(name: "ChelseaMarket-Regular", size: 25)
        presentationText.textColor = .white
        presentationText.text = firstPhrase
        presentationText.textAlignment = .center
        presentationText.lineBreakMode = .byWordWrapping
        presentationText.numberOfLines = 0
        view.addSubview(presentationText)
        
        //Configura o botão
        skipButton.frame = CGRect (x: size.width * 0.85, y: size.height * 0.07, width: 70, height: 20)
        skipButton.titleLabel?.font = UIFont(name: "ChelseaMarket-Regular", size: 15)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.setImage(UIImage(named:"BackArrow"), for:.normal)
        skipButton.setTitle("Pular",for: .normal)
        //Ajusta a posição do texto e da setinha no botão
        skipButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        skipButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 60, bottom: 0, right: 0)
        //Se o botão for pressionado, a função pressedSkip é chamada
        skipButton.addTarget(self, action: #selector(pressedSkip), for: .touchUpInside)
        
        view.addSubview(skipButton)
        
        //Sempre que houver algum toque/arrasta dedo/etc, a função de mudança de página é chamada
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        
        //Chamada sempre que houver um toque para "frente"
        pageControl.addTarget(self, action: #selector(lastPage), for: .touchUpInside)
        
    }
    
    @IBAction func pageChanged(){
        //Muda texto da label, posições do sol e do céu, dependendo da página (sim eu usei switch)
        switch pageControl.currentPage {
    
        case 0:
            presentationText.text = firstPhrase
            sky.run(SKAction.move(to: CGPoint(x: floor.position.x, y: floor.position.y + 210), duration: 1))
            sun.run(SKAction.move(to: CGPoint(x: size.width * 0.9, y: floor.position.y), duration: 1))
            skipButton.isHidden = false
            //Sempre que muda a página, a flag é setada para zero, indicando que acabou de entrar na página atual
            lastPageFlag = 0
            
        case 1:
            presentationText.text = secondPhrase
            sky.run(SKAction.move(to: CGPoint(x: floor.position.x, y: floor.position.y + 180), duration: 1))
            sun.run(SKAction.move(to: CGPoint(x: (size.width * 0.9) + 30, y: floor.position.y - 20), duration: 1))
            skipButton.isHidden = false
            lastPageFlag = 0
            
        case 2:
            presentationText.text = thirdPhrase
            sky.run(SKAction.move(to: CGPoint(x: floor.position.x, y: floor.position.y + 150), duration: 1))
            sun.run(SKAction.move(to: CGPoint(x: (size.width * 0.9) + 60, y: floor.position.y - 40), duration: 1))
            skipButton.isHidden = false
            lastPageFlag = 0
            
        case 3:
            presentationText.text = fourthPhrase
            sky.run(SKAction.move(to: CGPoint(x: floor.position.x, y: floor.position.y + 120), duration: 1))
            sun.run(SKAction.move(to: CGPoint(x: (size.width * 0.9) + 90, y: floor.position.y - 60), duration: 1))
            skipButton.isHidden = false
            lastPageFlag = 0
            
        case 4:
            presentationText.text = fifthPhrase
            sky.run(SKAction.move(to: CGPoint(x: floor.position.x, y: floor.position.y + 90), duration: 1))
            sun.run(SKAction.move(to: CGPoint(x: (size.width * 0.9) + 120, y: floor.position.y - 80), duration: 1))
            //o botão de pular é escondido na última página
            skipButton.isHidden = true
            lastPageFlag = 0
            
        default:
            print("Page doesn't exists!")
        }
    }
    
    @IBAction func pressedSkip(_ sender: UIButton){
        //Chama a função para mudar para a próxima cena
        nextScreen()
    }
    
    @IBAction func lastPage(){
        //Ao clicar para frente, checa se já está na última página
        if pageControl.currentPage == 4 {
            //se estiver, adiciona um à flag (ela entra nessa função logo que entra na página)
            lastPageFlag = lastPageFlag + 1
            //Se a flag tiver valor maior do que 1, indica que houve um toque para frente na última página
            if lastPageFlag > 1 {
                //Chama a função para mudar para a próxima cena
                nextScreen()
            }
        }
    }
    
    private func nextScreen(){
        //Esconde a label (como é subview, não tem como aplicar a ação de fade out
        presentationText.isHidden = true
        
        //Remove as subviews (page control, botão e label) da view principal
        pageControl.removeFromSuperview()
        skipButton.removeFromSuperview()
        presentationText.removeFromSuperview()
        
        //Define a ação de desaparecer (fade Out)
        let finalAction = SKAction.fadeOut(withDuration: 0.5)
        
        //Aplica a ação de fade out aos elementos da cena (céu, sol e chão) e os esconde
        sky.run(finalAction) {
            self.sky.isHidden = true
        }
        floor.run(finalAction){
            self.floor.isHidden = true
        }
        sun.run(finalAction){
            self.sun.isHidden = true
            //Chama a cena de escolha da Lenda
            self.view?.presentScene(CrossroadsScene(size: self.size))
        }
    }
}
