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
    override func didMove(to view: SKView) {
        print("Entrou na encruzilhada!!!")
    }
    
    //Função que identifica quando há toques na tela
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Chama a cena da lenda
        self.view?.presentScene(MaeDaguaScene(size: self.size))
    }
}
