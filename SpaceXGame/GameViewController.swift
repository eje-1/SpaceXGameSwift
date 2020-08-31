//
//  GameViewController.swift
//  SpaceXGame
//
//  Created by Ernest Jewczyn on 07.08.20.
//  Copyright © 2020 Ernest Jewczyn. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //bounds sind auser rander von view  unser secen wird immer so goross wie das hande "self.view.bounds.size"
        let scene = LoginView(size: self.view.bounds.size)
        
        //Hier wandlen wir den view zu SKView mit "as!"
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = false // ziegt wo der schiff getroffen werden kann
        skView.ignoresSiblingOrder = true
        
        //welche scene sollte angezeigt werden
        skView.presentScene(scene)
        
    }
        

}
