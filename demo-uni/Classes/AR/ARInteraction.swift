//
//  ARInteraction.swift
//  demo-uni
//
//  Created by Tim Zagirov on 08/03/2019.
//  Copyright © 2019 Tim Zagirov. All rights reserved.
//
import UIKit
import ARKit

protocol ARInteractionsProtocol
{
    func interactingNode(gesture: UIGestureRecognizer) -> ARInteractionsProtocol!
    func rotate(gesture: UIRotationGestureRecognizer, sceneView: ARSCNView)
    func pan(gesture: UIPanGestureRecognizer, sceneView: ARSCNView, planeAnchor: ARPlaneAnchor)
    func pinch(gesture: UIPinchGestureRecognizer, sceneView: ARSCNView)
    func tap(gesture: UITapGestureRecognizer, sceneView: ARSCNView)
}

class ARInteractions:NSObject, UIGestureRecognizerDelegate {
    
    var sceneView: ARSCNView!
    var selectedObject: ARInteractionsProtocol?
    var trackingObjectPositions = [SCNVector3]()
    var planeAnchor: ARPlaneAnchor!
    {
        didSet {
            planeAnchorYPosition = planeAnchor.transform.columns.3.y
        }
    }
    
    var center: CGPoint!
    
    private var planeAnchorYPosition:Float!
    
    init(sceneView: ARSCNView) {
        super.init()
        
        self.sceneView = sceneView
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tapGesture.delegate = self
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        
        let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        
        DispatchQueue.main.async {
            self.center = sceneView.center
            self.sceneView!.addGestureRecognizer(tapGesture)
            self.sceneView!.addGestureRecognizer(panRecognizer)
            self.sceneView!.addGestureRecognizer(rotationRecognizer)
            self.sceneView!.addGestureRecognizer(pinchRecognizer)
        }
    }
    
    @objc func didPinch(_ gesture: UIPinchGestureRecognizer)
    {
        switch gesture.state {
        case .began:
            guard let interactingNode = interactingNode(gesture: gesture) else {return}
            selectedObject = interactingNode
        case .changed:
            selectedObject?.pinch(gesture: gesture, sceneView: sceneView)
        case .ended:
            fallthrough
        default:
            selectedObject = nil
        }
    }
    
    @objc func didTap(_ gesture: UITapGestureRecognizer)
    {
        guard let interactingNode = interactingNode(gesture: gesture) else {return}
        interactingNode.tap(gesture: gesture, sceneView: sceneView)
    }
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer)
    {
        switch gesture.state {
        case .began:
            guard let interactingNode = interactingNode(gesture: gesture) else {return}
            selectedObject = interactingNode
        case .changed:
            selectedObject?.pan(gesture: gesture, sceneView: sceneView, planeAnchor: planeAnchor)
        case .ended:
            fallthrough
        default:
           selectedObject = nil
        }
        
    }
    @objc func didRotate(_ gesture: UIRotationGestureRecognizer)
    {
        switch gesture.state {
        case .began:
            guard let interactingNode = interactingNode(gesture: gesture) else {return}
            selectedObject = interactingNode
        case .changed:
            selectedObject?.rotate(gesture: gesture, sceneView: sceneView)
        case .ended:
            fallthrough
        default:
            selectedObject = nil
        }
        
    }
    
    func trackObject(node: SCNNode!)
    {
        guard let trackingObject = node else {return}
        let hitTest = sceneView!.hitTest(center!, types: .existingPlane)
        let result = hitTest.last
        guard let transform = result?.worldTransform else {return}
        let thirdColumn = transform.columns.3
        let position = SCNVector3Make(thirdColumn.x, planeAnchorYPosition, thirdColumn.z)
        trackingObjectPositions.append(position)
        let newPosition = trackingObjectPositions.reduce(SCNVector3Zero, +) / Float(trackingObjectPositions.count)
        DispatchQueue.main.async {
            trackingObject.position = newPosition
        }
        trackingObjectPositions = Array(trackingObjectPositions.suffix(10))
    }
    
    private func interactingNode(gesture: UIGestureRecognizer) -> ARInteractionsProtocol!
    {
        guard let nodeUnderTouch = sceneView?.nodeAt(point: gesture.location(in: sceneView)) else {return nil}
        if(nodeUnderTouch is ARInteractionsProtocol)
        {
           return (nodeUnderTouch as? ARInteractionsProtocol)?.interactingNode(gesture: gesture)
        }
        else
        {
           return (SCNNode.lastNode(nodeUnderTouch) as? ARInteractionsProtocol)?.interactingNode(gesture: gesture)
        }
    }
    
//    private func objectInteracting(with gesture: UIGestureRecognizer, in view: ARSCNView) -> SCNNode! {
//        for index in 0..<gesture.numberOfTouches {
//            let touchLocation = gesture.location(ofTouch: index, in: view)
//            if let object = view.nodeAt(point: touchLocation) {
//                return SCNNode.lastNode(object)
//            }
//        }
//        return sceneView?.nodeAt(point: gesture.center(in: view))
//        
//    }
}

extension SCNNode {
    static func lastNode(_ testNode: SCNNode!) -> SCNNode! {
        guard let node = testNode else {return nil}
        if node.parent != nil && node.parent!.name != nil {
            return lastNode(node.parent!)
        }
        else {
            return node
        }
    }
}

extension ARSCNView {
    func nodeAt(point: CGPoint) -> SCNNode! {
        let hitTestOptions: [SCNHitTestOption: Any] = [.boundingBoxOnly: true]
        let hitTestResults = hitTest(point, options: hitTestOptions)
        return hitTestResults.first?.node
    }
}

extension UIGestureRecognizer {
    func center(in view: UIView) -> CGPoint
    {
        let first = CGRect(origin: location(ofTouch: 0, in: view), size: .zero)
        
        let touchBounds = (1..<numberOfTouches).reduce(first) { touchBounds, index in
            return touchBounds.union(CGRect(origin: location(ofTouch: index, in: view), size: .zero))
        }
        return CGPoint(x: touchBounds.midX, y: touchBounds.midY)
    }
}


