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
    override func pan(gesture: UIPanGestureRecognizer, sceneView: ARSCNView) {
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
    
    var isHighlighted = false
    
    private var highlighterScene:SCNScene!
    private var highlighterNode:SCNNode!
    private var planeAnchor: ARPlaneAnchor!
    private var planeAnchorYPosition:Float!
    private var offset:SCNVector3!
    override init() {
        super.init()
        highlighterScene = SCNScene(named: "assets.scnassets/highlighter.scn")
        highlighterNode = highlighterScene?.rootNode.childNode(withName: "highlighter", recursively: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func interactingNode(gesture: UIGestureRecognizer) -> ARInteractionsProtocol! {
        
        return self
    }
    
    override func preparation(gesture: UIGestureRecognizer, sceneView: ARSCNView, planeAnchor: ARPlaneAnchor) {
        highlight()
        self.planeAnchor = planeAnchor
        planeAnchorYPosition = planeAnchor.transform.columns.3.y
        let touchesLocation = gesture.location(in: sceneView)
        let hitTestOptions: [SCNHitTestOption: Any] = [.boundingBoxOnly: true]
        let detectedGeometry = sceneView.hitTest(touchesLocation, options: hitTestOptions)
        offset = SCNVector3Zero
        guard let geometryPosition = detectedGeometry.first?.worldCoordinates  else {return}
        offset = SCNVector3(self.position.x - geometryPosition.x, 0, self.position.z - geometryPosition.z)
    }
    
    override func pan(gesture: UIPanGestureRecognizer, sceneView: ARSCNView) {
        let touchesLocation = gesture.location(in: sceneView)
        let detectedPlane = sceneView.hitTest(touchesLocation, types: [.existingPlane])
        guard let transform = detectedPlane.first?.worldTransform else {return}
        let thirdColumn = transform.columns.3
        let position = SCNVector3Make(thirdColumn.x, planeAnchorYPosition, thirdColumn.z)
        self.position = position + offset
    }
    override func rotate(gesture: UIRotationGestureRecognizer, sceneView: ARSCNView) {
        self.eulerAngles = self.eulerAngles - SCNVector3(0, gesture.rotation, 0)
        gesture.rotation = 0
    }
    
    override func tap(gesture: UITapGestureRecognizer, sceneView: ARSCNView) {
        if(isHighlighted)
        {
            removeHighlight()
        }
        else
        {
            highlight()
        }
    }
    
    func highlight()
    {
        if(isHighlighted) {return}
        guard let highlighter = highlighterNode else {return}
        isHighlighted = true
        DispatchQueue.main.async {
            self.addChildNode(highlighter)
        }
    }
    
    func removeHighlight()
    {
        if(!isHighlighted) {return}
        guard let highlighter = highlighterNode else {return}
        DispatchQueue.main.async {
            highlighter.removeFromParentNode()
        }
        isHighlighted = false
    }
}
