//
//  ExpressionLabelScene.swift
//  Calculator
//
//  Created by crescenzo garofalo on 09/06/2017.
//  Copyright © 2017 Enzo Garofalo. All rights reserved.
//

import Foundation
import SpriteKit

class ExpressionLabelScene : SKScene {
    
    var contentCreated = false
    
    override func didMove(to view: SKView) {
        if self.contentCreated == false {
            self.createSceneContents()
            self.contentCreated = true
        }
    }
    
    func createSceneContents() {
        self.backgroundColor = SKColor.red
        self.scaleMode = SKSceneScaleMode.aspectFit
    }
    
}
