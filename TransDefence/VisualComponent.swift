//
//  VisualComponent.swift
//  TransDefence
//
//  Created by Xavi Loinaz on 11/7/15.
//  Copyright © 2015 Xavi Loinaz and William Park. All rights reserved.
//

import GameplayKit
import SpriteKit

class VisualComponent: GKComponent {
    
    var scene: GameScene!
    var sprite: SKSpriteNode!
    var coordinate: int2!
    
    init(scene: GameScene, sprite: SKSpriteNode, coordinate: int2) {
        self.scene = scene
        self.sprite = sprite
        self.coordinate = coordinate
    }
    
}
