//
//  GameViewController.swift
//  Lendario
//
//  Created by Fenda do Biquini on 25/06/20.
//  Copyright © 2020 Fenda do Biquini. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Descobrir os nomes das fontes disponíveis
        /*for family: String in UIFont.familyNames{
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }*/
        
        //Função que define a cena inicial do jogo (Tela inicial)
        if let view = self.view as! SKView? {
            
            //Configura a MainScene para ter o mesmo tamanho da view
//            let scene = MainScene(size: view.bounds.size)
            let scene = MaeDaguaSecondScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            
            //Chama a MainScene
            view.presentScene(scene)
            
            //A Boolean value that indicates whether parent-child and sibling relationships affect the rendering order of nodes in the scene (vem como padrão)
            view.ignoresSiblingOrder = true
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
