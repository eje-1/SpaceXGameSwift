    //
    //  GameScene.swift
    //  SpaceXGame
    //
    //  Created by Ernest Jewczyn on 07.08.20.
    //  Copyright © 2020 Ernest Jewczyn. All rights reserved.
    //
    
    import SpriteKit
    import AVFoundation
    
    class GameScene: SKScene, SKPhysicsContactDelegate {
        
        //Die klasse SKSpriteNode aufnmmit bilder
        //Image konstante
        var spaceShip = SKSpriteNode()
        let backgroundScene = SKSpriteNode(imageNamed: "background")
        let backgroundScene2 = SKSpriteNode(imageNamed: "background")
        var spaceShipTexture = SKTexture(imageNamed: "spaceship")
        
        //Audio Variable
        var audioPlayer: AVAudioPlayer = AVAudioPlayer()
        var backgroundAudio: URL?
        
        //let soundON = SKShapeNode(circleOfRadius: 20)
        //let soundOFF = SKShapeNode(circleOfRadius: 20)
        
        let soundON = SKSpriteNode(imageNamed: "soundOn")
        let soundOFF = SKSpriteNode(imageNamed: "soundOff")
        var check = true
        
        var timerEnemy = Timer()
        
        //Label
        var highScoreLabel = SKLabelNode(fontNamed: "Arial")
        var currentScoreLabel = SKLabelNode(fontNamed: "Arial")
        var currentScore = 0
        var highScore = UserDefaults.standard.integer(forKey: "HIGHSCORE")
        
        
        struct physicsBodyNummber {
            
            static let spaceShipNummber: UInt32 = 0b1 //1
            static let bulletNummber: UInt32 = 0b10 // 2
            static let enemyNummber: UInt32 = 0b100 //4
            static let emptyNummber: UInt32 = 0b1000 // 8
        }
        
        
        
        // Das ist die erste funkton die aufgerufen wird
        override func didMove(to view: SKView) {
            
            
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            self.physicsWorld.contactDelegate = self
            
            /*** ****************SPACESHIP*****************/
            
            spaceShip = SKSpriteNode(texture: spaceShipTexture)
            
            //Hier wird positioniten wo der schif bei laden des app sein wird
            spaceShip.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 350)
            
            // Die grosse von space ship 1.0 ist 100%
            spaceShip.setScale(0.15)
            spaceShip.zPosition = 1
            
            //es funktionite nicht zu zeit
            spaceShip.physicsBody = SKPhysicsBody(texture: spaceShipTexture, size: spaceShip.size) // der kreis sollte so sein wie der ship
            //spaceShip.physicsBody = SKPhysicsBody(circleOfRadius: spaceShip.size.width / 2) // der kreis objekt was interagiren kann das der schif schaden annehmen kann
            spaceShip.physicsBody?.affectedByGravity = false
            spaceShip.physicsBody?.categoryBitMask = physicsBodyNummber.spaceShipNummber
            spaceShip.physicsBody?.collisionBitMask = physicsBodyNummber.emptyNummber // unsere schiff kann nicht in eine kolizion jetzt verwikeln werden dank empty
            
            spaceShip.physicsBody?.contactTestBitMask = physicsBodyNummber.enemyNummber
            
            // addChild editire mein kind in dem fall mein space ship
            self.addChild(spaceShip)
            
            //Hintergrund ändern mit SKColor rgb(0,104,139) alpha wert ist der transparet
            self.backgroundColor = SKColor(displayP3Red: 0, green: 104 / 255, blue: 139 / 255, alpha: 1.0)
            
            backgroundScene.anchorPoint = CGPoint.zero // Position 0/0 0auf der x achse und 0y achse axse m
            backgroundScene.position = CGPoint.zero
            backgroundScene.size = self.size
            backgroundScene.zPosition = -1
            self.addChild(backgroundScene)
            
            backgroundScene2.anchorPoint = CGPoint.zero
            backgroundScene2.position.x = 0
            backgroundScene2.position.y = backgroundScene.size.height - 5
            backgroundScene2.size = self.size
            backgroundScene2.zPosition = -1
            self.addChild(backgroundScene2)
            
            //Audio
            backgroundAudio = Bundle.main.url(forResource: "AudioS", withExtension: "mp3")
            
            //soundON.fillColor = SKColor.blue
            //soundON.strokeColor = SKColor.clear //es ist umrandung standar ist der weiss
            soundON.setScale(0.08)
            soundON.position = CGPoint(x: self.size.width - soundON.frame.size.width, y: soundON.frame.size.height)
            self.addChild(soundON)
            
            //soundOFF.fillColor = SKColor.red
            //soundOFF.strokeColor = SKColor.clear //es ist umrandung standar ist der weiss
            soundOFF.setScale(0.08)
            soundOFF.position = CGPoint(x: soundOFF.frame.size.width, y: soundOFF.frame.size.height)
            self.addChild(soundOFF)
            
            //Label
            
            highScoreLabel.fontSize = 20
            highScoreLabel.text = "Highscore: \(UserDefaults.standard.integer(forKey: "HIGHSCORE"))"
            highScoreLabel.zPosition = 1
            highScoreLabel.position = CGPoint(x: self.size.width - highScoreLabel.frame.size.width - 1, y: self.size.height - highScoreLabel.frame.size.height - 30)
            self.addChild(highScoreLabel)
            
            currentScoreLabel.fontSize = 20
            currentScoreLabel.text = "Gamescore: \(currentScore)"
            currentScoreLabel.zPosition = 1
            currentScoreLabel.position = CGPoint(x: highScoreLabel.position.x, y: highScoreLabel.position.y - currentScoreLabel.frame.size.height - 10)
            self.addChild(currentScoreLabel)
            
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: backgroundAudio!)
            }catch{
                print("Datei nicht gefunden")
            }
            
            audioPlayer.numberOfLoops = -1  // OK -1 bedeutet fall wenn die musick zu ende ist wird die nie aus gehen aber wenn da 1 oder 2 oder 3 wäre dann spielt es so oft wie die zahl steht
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            timerEnemy = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(GameScene.addEnemy), userInfo: nil, repeats: true)
            addLiveToSpaceShip(liveNum: 3)
            enemyRemoveLive()
            
        }
        
        // Save aktuelle record
        func saveHighScore(){
            
            UserDefaults.standard.set(currentScore, forKey: "HIGHSCORE")
            highScoreLabel.text = "Highscore: \(UserDefaults.standard.integer(forKey: "HIGHSCORE"))"
        }
        
        func addLiveToSpaceShip(liveNum: Int){
            
            let liveCount: Int = liveNum - 1 // 3 leben anstatt 4 weil -1 die schleife fang von 0 zu zahlen
            
            for index in 0...liveNum{
                
                let liveNode = SKSpriteNode(imageNamed: "heart")
                
                liveNode.setScale(0.03)
                liveNode.anchorPoint = CGPoint(x: -1.5, y: 1) // wo befindet sich die lebens
                liveNode.position.x = CGFloat(index) * liveNode.size.width
                liveNode.position.y = self.size.height - liveNode.size.height
                liveNode.zPosition = 3
                self.addChild(liveNode)
                
            }
            
        }
        
        func enemyRemoveLive(){
                
        

            
        }
        
        func addBulletToSpaceship(){
            
            let bulletTextur = SKTexture(imageNamed: "bullet")
            // hier setzen wir das bild von schuss
            let bullet = SKSpriteNode(texture: bulletTextur)
            
            // bullet mit unseren schif binden
            bullet.position = spaceShip.position
            bullet.zPosition = 0
            bullet.name = "bullet"
            
            //Grosse von schuss
            bullet.setScale(0.25)
            
            bullet.physicsBody = SKPhysicsBody(texture: bulletTextur, size: bullet.size) // es funktioniret nicht so wirklich
            //bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2) // unsere geschoss wird auch zu einem spiel objekt
            bullet.physicsBody?.isDynamic = false // unsere beschuss wird nicht dem gravitazion kaften nicht erfassen
            bullet.physicsBody?.categoryBitMask = physicsBodyNummber.bulletNummber
            bullet.physicsBody?.contactTestBitMask = physicsBodyNummber.enemyNummber // falls der gegner getroffen wird dann explodiret kolizion
            
            
            self.addChild(bullet)
            
            //Action
            
            let moveTO = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 3) // duration ist der zeit
            let delete = SKAction.removeFromParent()
            
            // Wir ubergeben hier die actions sequence nach dem der move to unser position erreicht hat kann er gelöst werden "delete"
            bullet.run(SKAction.sequence([moveTO, delete]))
            
        }
        
        @objc func addEnemy(){
            
            var enemyArray = [SKTexture]()
            
            for index in 1...8{
                enemyArray.append(SKTexture(imageNamed: "\(index)"))
            }
            
            let enemyTextur = SKTexture(imageNamed: "spaceship_enemy_start")
            let enemy = SKSpriteNode(texture: enemyTextur)
            
            //enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemy.size.width / 2, height: enemy.size.height / 2))
            enemy.physicsBody = SKPhysicsBody(texture: enemyTextur, size: enemy.size)
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.categoryBitMask = physicsBodyNummber.enemyNummber
            enemy.physicsBody?.collisionBitMask = physicsBodyNummber.emptyNummber | physicsBodyNummber.spaceShipNummber  // Kolizion zwischen schuss und schif
            enemy.physicsBody?.contactTestBitMask = physicsBodyNummber.bulletNummber
            
            enemy.setScale(0.10)
            enemy.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.size.width))) + 20, y: self.size.height + enemy.size.height) //der spown platz
            enemy.zRotation = CGFloat(((Double.pi / 180) * 180)) //der schif um 180 umdrehen
            
            self.addChild(enemy) // jedes mal muss es extra hinzugefugt werden addChild
            
            // Action
            
            enemy.run(SKAction.repeatForever(SKAction.animate(with: enemyArray, timePerFrame: 0.1))) // gegner sind dauerhaft gespont in zeit von 1 sekunde
            
            let moveDown = SKAction.moveTo(y: -enemy.size.height, duration: 3) // gegner bewegen sich nach untern
            let delete = SKAction.removeFromParent() // nach dem der gegner der diplayoberflache beendet hat wird der gelöst
            
            enemy.run(SKAction.sequence([moveDown,delete]))
            
        }
        
        var enemyHitSound: Bool = true
        
        func getKontaktBullet(bullet: SKSpriteNode, enemy: SKSpriteNode) {
            
            let explo = SKEmitterNode(fileNamed: "enemyFire.sks")
            explo?.position = enemy.position
            explo?.zPosition = 2
            self.addChild(explo!)
            
            self.run(SKAction.wait(forDuration: 2)) { // forDuration ist wie lange sollte das action da sein z.B "2s"
                
                explo?.removeFromParent()
                
            }
            
            bullet.removeFromParent()
            enemy.removeFromParent()
            
            if enemyHitSound == true{
                
                self.run(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true))
                
            }
            
            currentScore += 1
            currentScoreLabel.text = "Gamescore: \(currentScore)"

            
        }
        
        func getContactSpaceshipVSEnemy(spaceship: SKSpriteNode, enemy: SKSpriteNode){
            
            let explo = SKEmitterNode(fileNamed: "enemyFire.sks")
            explo?.position = enemy.position
            explo?.zPosition = 2
            self.addChild(explo!)
            
            self.run(SKAction.wait(forDuration: 2)) { // forDuration ist wie lange sollte das action da sein z.B "2s"
                explo?.removeFromParent()
            }
            
            enemy.removeFromParent()
            if enemyHitSound == true{
                
                self.run(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true))
            }
            
            spaceship.run(SKAction.repeat(SKAction.sequence([SKAction.fadeAlpha(to: 0.1, duration: 0.1),SKAction.fadeAlpha(to: 1.0, duration: 0.1)]), count: 5)) // Spaceship wird bei treffen durchsichtig 10 mal
            
        }
        
        
        //damit der enemy nur eim male explodiret
        var contactBegin: Bool = true
        
        // hier findet statt die ganze explosion von objekten "remove"
        func didBegin(_ contact: SKPhysicsContact) {
            
            let conractMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
            
            switch conractMask {
            case physicsBodyNummber.bulletNummber | physicsBodyNummber.enemyNummber:
                // Kontak bullte vs enemy
                
                //contact.bodyA.node?.removeFromParent() // switch fall unterscheidung bei treffen des gegner
                //contact.bodyB.node?.removeFromParent()
                
                if contactBegin{
                    
                    do {
                        try! getKontaktBullet(bullet: contact.bodyA.node as! SKSpriteNode, enemy: contact.bodyB.node as! SKSpriteNode)
                        contactBegin = false
                    } catch {
                        print(error)
                    }
                    
                }
                
            case physicsBodyNummber.spaceShipNummber | physicsBodyNummber.enemyNummber:
                // Kontak spaceship vs enemy
                
                guard let node1 = contact.bodyA.node else {
                    print("notFound")
                    return
                }
                
                guard let node2 = contact.bodyB.node else {
                    print("notFound")
                    return
                }
                getContactSpaceshipVSEnemy(spaceship: node1 as! SKSpriteNode, enemy: node2 as! SKSpriteNode)

                
            default:
                break
            }
            
        }
        
        func didEnd(_ contact: SKPhysicsContact) {
            
            if contact.bodyA.node?.name == "bullet" || contact.bodyB.node?.name == "bullte"{
                
                contactBegin = true
            }
        }
        
        // Methode Set UITOUCH obiekte haben immer die position von user wo der grade auf dem display getipp hat
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            for touch in touches{
                
                //Wir speichen uns erstmal die position aus disem uiTouch objekt
                
                let userLocation = touch.location(in: self)
                //spaceShip kann sich auf die x achse bewegen
                spaceShip.position.x = userLocation.x
                //spaceShip kann sich auf die y achse bewegen
                spaceShip.position.y = userLocation.y
            }
        }
        
        // sound konstante und variable
        let bullutSound = SKAction.playSoundFileNamed("laser", waitForCompletion: true)
        var soundBulletONOFF: Bool = true
        
        
        // Alles mit toutch
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            for touch in touches{
                
                let locationUser = touch.location(in: self)
                
                if atPoint(locationUser) == spaceShip {
                    addBulletToSpaceship()
                    
                    if soundBulletONOFF == true {
                        
                        self.run(bullutSound, withKey: "bulletSound")
                    }
                    
                }
                
                if atPoint(locationUser) == soundOFF{  // Wenn der user auf roten button druck wird die music gestopt
                    audioPlayer.pause()
                    self.removeAction(forKey: "bulletSound")
                    soundBulletONOFF = false
                    enemyHitSound = false
                }
                
                if atPoint(locationUser) == soundON{ // wenn der user auf blauen button typ dann startet die music wieder
                    audioPlayer.play()
                    soundBulletONOFF = true
                    enemyHitSound = true
                }
                
            }
        }
        
        //die update funktion wird vor jeden frame abgerufen
        override func update(_ currentTime: TimeInterval) {
            
            //5 point pro fame wird unser background nach unter fahren
            backgroundScene.position.y -= 5
            backgroundScene2.position.y -= 5
            
            
            if backgroundScene.position.y < -backgroundScene.size.height{
                
                // neu positionirung des hintergrundes
                backgroundScene.position.y = backgroundScene2.position.y + backgroundScene2.size.height
            }
            
            if backgroundScene2.position.y < -backgroundScene2.size.height{
                
                backgroundScene2.position.y = backgroundScene.position.y + backgroundScene.size.height
            }
            
            if currentScore > UserDefaults.standard.integer(forKey: "HIGHSCORE"){
                saveHighScore()
            }
            
        }
        
        
    }
