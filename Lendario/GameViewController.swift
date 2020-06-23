//
//  GameViewController.swift
//  Lendario
//
//  Created by Jéssica Amaral on 22/06/20.
//  Copyright © 2020 Jéssica Amaral. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            let scene = MainScene(size: view.bounds.size)
            scene.scaleMode = .aspectFit
    
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
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
