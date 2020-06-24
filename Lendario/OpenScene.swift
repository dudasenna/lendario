//
//  OpenScene.swift
//  Lendario
//
//  Created by Jéssica Amaral on 23/06/20.
//  Copyright © 2020 Jéssica Amaral. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class OpenScene: SKScene {
    let sky = SKSpriteNode(imageNamed: "Céu")
    let floor = SKSpriteNode(imageNamed: "Chão")
    let sun = SKSpriteNode(imageNamed: "Sol")
    
    var firstPhrase: String!
    var secondPhrase: String!
    var thirdPhrase: String!
    var fourthPhrase: String!
    var fifthPhrase: String!
    
    var lastPageFlag: Int!
    
    var presentationText = UILabel()
    
    let pageControl = UIPageControl()
    
    let skipButton = UIButton()
    
    override func didMove(to view: SKView){
        self.anchorPoint = .zero
        
        pageControl.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        
        //changes the position of the dots to the bottom of the screen
        pageControl.layer.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 2)
        pageControl.layer.position.y = view.frame.height - 50
        view.addSubview(pageControl)
        
        floor.size = size
        floor.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        floor.zPosition = -1
        self.addChild(floor)
        
        sky.position = CGPoint(x: floor.position.x, y: floor.position.y + 210)
        sky.size.width = size.width
        sky.zPosition = -3
        self.addChild(sky)
        
        sun.size = CGSize(width: sun.size.width * 1.5, height: sun.size.height * 1.5)
        sun.position = CGPoint(x: size.width * 0.9, y: floor.position.y)
        sun.zPosition = -2
        self.addChild(sun)
        
        firstPhrase = "Olá! Aqui começa uma pequena jornada pelo folclore nordestino..."
        
        secondPhrase = "...Através de interações com o ambiente, você irá descobrir mais sobre as lendas da nossa região..."
        
        thirdPhrase = "...Você poderá descobrir lendas de acordo com o ambiente que preferir explorar!"
        
        fourthPhrase = "Para uma melhor experiência utilize fones de ouvido!!"
        
        fifthPhrase = "Vamos lá!"
        
        presentationText.frame = CGRect(x: size.width * 0.3, y: size.height * 0.3, width: size.width * 0.4, height:  size.height * 0.4)
        presentationText.font = UIFont(name: "ChelseaMarket-Regular", size: 25)
        presentationText.textColor = .white
        presentationText.text = firstPhrase
        presentationText.textAlignment = .center
        presentationText.lineBreakMode = .byWordWrapping
        presentationText.numberOfLines = 0
        view.addSubview(presentationText)
        
        skipButton.frame = CGRect (x: size.width * 0.85, y: size.height * 0.07, width: 70, height: 20)
        skipButton.titleLabel?.font = UIFont(name: "ChelseaMarket-Regular", size: 15)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.setImage(UIImage(named:"BackArrow"), for:.normal)
        skipButton.setTitle("Pular",for: .normal)
        skipButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        skipButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 60, bottom: 0, right: 0)
        skipButton.addTarget(self, action: #selector(pressedSkip), for: .touchUpInside)
        
        view.addSubview(skipButton)
        
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        
        pageControl.addTarget(self, action: #selector(lastPage), for: .touchUpInside)
        
    }
    
    @IBAction func pageChanged(){
        switch pageControl.currentPage {
            
        case 0:
            presentationText.text = firstPhrase
            sky.run(SKAction.move(to: CGPoint(x: floor.position.x, y: floor.position.y + 210), duration: 1))
            sun.run(SKAction.move(to: CGPoint(x: size.width * 0.9, y: floor.position.y), duration: 1))
            skipButton.isHidden = false
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
            skipButton.isHidden = true
            lastPageFlag = 0
            
        default:
            print("Page doesn't exists!")
        }
    }
    
    @IBAction func pressedSkip(_ sender: UIButton){
        nextScreen()
    }
    
    @IBAction func lastPage(){
        if pageControl.currentPage == 4 {
            lastPageFlag = lastPageFlag + 1
            if lastPageFlag > 1 {
                nextScreen()
            }
        }
    }
    
    private func nextScreen(){
        let finalAction = SKAction.fadeOut(withDuration: 0.5)
        
        sky.run(finalAction) {
            self.sky.isHidden = true
        }
        floor.run(finalAction){
            self.floor.isHidden = true
        }
        sun.run(finalAction){
            self.sun.isHidden = true
            self.view?.presentScene(CrossroadsScene(size: self.size))
        }
        
        presentationText.isHidden = true
        
        pageControl.removeFromSuperview()
        skipButton.removeFromSuperview()
        presentationText.removeFromSuperview()
    }
}
