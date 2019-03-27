//
//  VirtualObjects.swift
//  demo-uni
//
//  Created by Alexey Antipin on 25/03/2019.
//  Copyright © 2019 Tim Zagirov. All rights reserved.
//

import Foundation
import ARKit

class WallSegment: ExtendedNode
{
    var containedInWallChain:WallChain!
    var isTaped = false
    override func interactingNode(gesture: UIGestureRecognizer) -> ARInteractionsProtocol! {
        if (gesture is UITapGestureRecognizer) {
            return self
        }
        if (gesture is UIPanGestureRecognizer) {
            return self.parent as? ARInteractionsProtocol
        }
        return nil
    }
    
    override func tap(gesture: UITapGestureRecognizer, sceneView: ARSCNView) {
        if (!isTaped)
        {
            self.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 0.273, green: 0.508, blue: 0.703, alpha: 0.8)
            self.addGlow(sceneView: sceneView)
            containedInWallChain.tapedWallSegments.append(self)
        }
        else
        {
            self.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
            self.removeGlow(sceneView: sceneView)
            containedInWallChain.tapedWallSegments.removeAll(where: {$0 == self})
        }
        isTaped = !isTaped
    }
    
    func textureWall(textureLength: Float, textureWidth: Float, textureImage: Any!) {
        
        let texture = textureImage ?? UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        let lengthCount = self.scale.x / textureLength
        let widthCount = self.scale.y / textureWidth
        self.geometry?.firstMaterial?.diffuse.contents = texture
        self.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(lengthCount, widthCount, 0)
        self.geometry?.firstMaterial?.diffuse.wrapS = .repeat
        self.geometry?.firstMaterial?.diffuse.wrapT = .repeat
        self.isTaped = false
        
    }
    
}

class WallSegmentRoot: ExtendedNode
{
    override func pan(gesture: UIPanGestureRecognizer, sceneView: ARSCNView, planeAnchor: ARPlaneAnchor) {
        let offset = -0.00004 * gesture.velocity(in: sceneView).y
        let offsetVector = SCNVector3(0, offset, 0)
        let halfOffsetVector = offsetVector * 0.5
        DispatchQueue.main.async {
            self.childNodes.forEach{
                $0.scale = $0.scale + offsetVector
                $0.position = $0.position + halfOffsetVector
                ($0 as! WallSegment).textureWall(textureLength: 1, textureWidth: 1, textureImage: $0.geometry?.firstMaterial?.diffuse.contents)
            }
        }
    }
}

class Furniture:ExtendedNode
{
    override func pan(gesture: UIPanGestureRecognizer, sceneView: ARSCNView, planeAnchor: ARPlaneAnchor) {
        let touchesLocation = gesture.location(in: sceneView)
        let results = sceneView.hitTest(touchesLocation, types: [.existingPlaneUsingGeometry, .estimatedVerticalPlane, .estimatedHorizontalPlane])
        guard let transform = results.first?.worldTransform else {return}
        let thirdColumn = transform.columns.3
        let planeAnchorYPosition = planeAnchor.transform.columns.3.y
        let position = SCNVector3Make(thirdColumn.x, planeAnchorYPosition, thirdColumn.z)
        self.position = position
        print(sceneView.unprojectPoint(SCNVector3(touchesLocation.x, touchesLocation.y, 0)))
      

    }
    
    override func rotate(gesture: UIRotationGestureRecognizer, sceneView: ARSCNView) {
        self.eulerAngles = self.eulerAngles - SCNVector3(0, gesture.rotation, 0)
        gesture.rotation = 0
    }
    
}
