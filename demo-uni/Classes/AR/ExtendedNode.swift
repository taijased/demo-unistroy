//
//  ExtendedNode.swift
//  demo-uni
//
//  Created by Alexey Antipin on 10/03/2019.
//  Copyright © 2019 Tim Zagirov. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class ExtendedNode: SCNNode, ARInteractionsProtocol {
    func pan(gesture: UIPanGestureRecognizer, sceneView: ARSCNView, planeAnchor: ARPlaneAnchor) {
        
    }
    
    func interactingNode(gesture: UIGestureRecognizer) -> ARInteractionsProtocol! {
        return self
    }
    
    func rotate(gesture: UIRotationGestureRecognizer, sceneView: ARSCNView) {
        
    }
    
    func pinch(gesture: UIPinchGestureRecognizer, sceneView: ARSCNView) {
        
    }
    
    func tap(gesture: UITapGestureRecognizer, sceneView: ARSCNView) {
        
    }
}

extension SCNNode {
    public func addGlow(sceneView:ARSCNView)
    {
        self.categoryBitMask = 2
        if let path = Bundle.main.path(forResource: "NodeTechnique", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path)  {
                let dict2 = dict as! [String : AnyObject]
                let technique = SCNTechnique(dictionary:dict2)
                sceneView.technique = technique
            }
        }
    }
    public func removeGlow(sceneView:ARSCNView)
    {
        self.categoryBitMask = 1
        sceneView.technique = nil
    }
}
