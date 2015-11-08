//
//  MovementComponent.swift
//  TransDefence
//
//  Created by Xavi Loinaz on 11/7/15.
//  Copyright © 2015 Xavi Loinaz and William Park. All rights reserved.
//

import SpriteKit
import GameplayKit

class MovementComponent: VisualComponent {

    var destination: int2!
    
    init(scene: GameScene, sprite: SKSpriteNode, coordinate: int2, destination: int2) {
        self.destination = destination
        
        super.init(scene: scene, sprite: sprite, coordinate: coordinate)
    }
    
    func pathToDestination() -> [GKGridGraphNode] {
        let current = scene.graph.nodeAtGridPosition(coordinate)!
        let end = scene.graph.nodeAtGridPosition(destination)!
        return scene.graph.findPathFromNode(current, toNode: end) as! [GKGridGraphNode]
    }
    
    func followPath(path: [GKGridGraphNode]) {
        var sequence = [SKAction]()
        
        for node in path {
            let action = SKAction.moveTo(scene.pointForCoordinate(node.gridPosition), duration: 1)
            let update = SKAction.runBlock() { [unowned self] in
                self.coordinate = node.gridPosition
            }
            
            sequence += [action, update]
        }
        
        sprite.runAction(SKAction.sequence(sequence))
    }
    
}
