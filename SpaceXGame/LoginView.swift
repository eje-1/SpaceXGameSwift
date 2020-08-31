//
//  LoginView.swift
//  SpaceXGame
//
//  Created by Ernest Jewczyn on 10.08.20.
//  Copyright © 2020 Ernest Jewczyn. All rights reserved.
//

import Foundation
import SpriteKit

class LoginView: SKScene{
    
    // SKSpriteNode die klasse gibt uns die möglichkeit bilder zu nutzen
    let playButton = SKSpriteNode(imageNamed: "Start")
    var background = SKSpriteNode(imageNamed: "background1")
    
    override func didMove(to view: SKView) {
        
        //Play button positioniren   // self die eigene szene dann die grosse und die breite geteilte durch 2
        playButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        playButton.setScale(0.5) // die grosse von button
        self.addChild(playButton)
        
        background.position = CGPoint(x: self.size.width / 2 , y: self.size.height / 2)
        addChild(background)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let userLocation = touch.location(in: self) // sieth aktuel wo der user gedruck hat
            
            if atPoint(userLocation) == playButton || atPoint(userLocation) == background {
                
                let ubergang = SKTransition.doorsOpenHorizontal(withDuration: 2) // Hire ein klein ubergang durch SKTransition 2 sind sekunden
                
                
                let gameScene = GameScene(size: self.size)  //<< die gameScene sollte genau so sein wie der loginView
                self.view?.presentScene(gameScene, transition: ubergang) // hier ist der verbindung zur gameScene
            }
        }
    }
}
