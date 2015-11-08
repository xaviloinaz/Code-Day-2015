//
//  GameScene.swift
//  TransDefence
//
//  Created by Xavi Loinaz on 11/7/15.
//  Copyright (c) 2015 Xavi Loinaz and William Park. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var width: CGFloat!
    var height: CGFloat = 9
    var boxSize: CGFloat!
    var gridStart: CGPoint!
    var graph: GKGridGraph!
    var enemies = [GKEntity]()
    
    override func didMoveToView(view: SKView) {
        createGrid()
        graph = GKGridGraph(fromGridStartingAt: int2(0, 0), width: Int32(width), height: Int32(height), diagonalsAllowed: false)
        createEnemies()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInNode(self)
        
        let coordinate = coordinateForPoint(location)
        createTowerAtCoordinate(coordinate)
    }
   
    override func update(currentTime: CFTimeInterval) {
       
    }
    
    func coordinateForPoint(point: CGPoint) -> int2 {
        return int2(Int32((point.x - gridStart.x) / boxSize), Int32((point.y - gridStart.y) / boxSize))
    }
    
    func pointForCoordinate(coordinate: int2) -> CGPoint {
        return CGPointMake(CGFloat(coordinate.x) * boxSize + gridStart.x + boxSize / 2, CGFloat(coordinate.y) * boxSize + gridStart.y + boxSize / 2)
    }
    
    func createTowerAtCoordinate(coordinate: int2) {
        if let node = graph.nodeAtGridPosition(coordinate) {
            let tower = GKEntity()
            
            let towerSprite = SKSpriteNode(imageNamed: "turret1 basic")
            towerSprite.position = pointForCoordinate(coordinate)
            towerSprite.size = CGSize(width: boxSize * 0.9, height: boxSize * 0.9)
            
            let visualComponent = VisualComponent(scene: self, sprite: towerSprite, coordinate: coordinate)
            tower.addComponent(visualComponent)
            
            addChild(towerSprite)
            
            graph.removeNodes([node])
            // update path
        }
    }
    
    func createGrid() {
        let grid = SKNode() // create a node to hold all grid squares
        
        let usableWidth = size.width * 0.9 // we only want to use 90% of the width available
        let usableHeight = size.height * 0.8 // we only want to use 80% of the height available
        
        boxSize = usableHeight / height // calculate the box size based on requested height
        
        width = CGFloat(Int(usableWidth / boxSize)) // calculate number of boxes along the x axis based on boxSize
        
        let offsetX = (size.width - boxSize * width) / 2 // used to center the grid horizontally
        let offsetY = (size.height - boxSize * height) / 2 // used to center the grid vertically
        
        // loop through the entire grid
        for col in 0 ..< Int(width) {
            for row in 0 ..< Int(height) {
                let path = UIBezierPath(rect: CGRect(x: boxSize * CGFloat(col), y: boxSize * CGFloat(row), width: boxSize, height: boxSize))
                let box = SKShapeNode(path: path.CGPath)
                box.strokeColor = UIColor.grayColor()
                box.alpha = 0.3
                grid.addChild(box)
            }
        }
        
        gridStart = CGPointMake(offsetX, offsetY) // set gridStart for later use
        grid.position = CGPointMake(offsetX, offsetY) // set the grid position, centered in view
        addChild(grid) // add the grid to the scene
    }
    
    func createEnemies() {
     
        let enemy = GKEntity()
        let gridPosition = int2(0, Int32(height) / 2)
        let destination = int2(Int32(width) - 1, Int32(height) / 2)
        
        let sprite = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: boxSize * 0.6, height: boxSize * 0.6))
        sprite.position = pointForCoordinate(gridPosition)
        
        let movementComponent = MovementComponent(scene: self, sprite: sprite, coordinate: gridPosition, destination: destination)
        enemy.addComponent(movementComponent)
        
        enemies.append(enemy)
        
        // Add enemies to game
        var sequence = [SKAction]()
        
        for enemy in enemies {
            let action = SKAction.runBlock() { [unowned self] in
                let movementComponent = enemy.componentForClass(MovementComponent)!
                self.addChild(movementComponent.sprite)
                
                // update path
                
                // temporary code to add movement
                let path = movementComponent.pathToDestination()
                movementComponent.followPath(path)
            }
            
            let delay = SKAction.waitForDuration(2)
            
            sequence += [action, delay]
        }
        
        runAction(SKAction.sequence(sequence))
    }
    
}
