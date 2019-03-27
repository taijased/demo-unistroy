
import Foundation
import ARKit

class WallChain {
    var sceneView: ARSCNView!
    var points = [SCNVector3]()
    
    var wallHeigth:CGFloat = 1
    var wallColor:UIColor!
    
    var wallRootNode = WallSegmentRoot()
    var wallNodes = [WallSegment]()
    
    var tapedWallSegments = [WallSegment]()
    
    func buildWalls()
    {
        let color = wallColor ?? UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        
        var firstPoint = points.first
        for point in points.dropFirst() {
            var position = (firstPoint! + point) * 0.5
            position = position + SCNVector3(0, 0.5 * wallHeigth, 0)
            let direction = point - firstPoint!
            let yRotation = atan2f(direction.x, direction.z) + .pi * 0.5
            let eulerAngles = SCNVector3(x: 0, y: yRotation, z: 0)
            let width = norm(direction)
            let plane = GeometryPrimitives.createPlane(CGFloat(width), wallHeigth, position, eulerAngles, color)
            plane.containedInWallChain = self
            wallNodes.append(plane)
            wallRootNode.addChildNode(plane)
            firstPoint = point
        }
        wallRootNode.name = "wall root"
        sceneView.scene.rootNode.addChildNode(wallRootNode)
    }
    
    func textureTapedNode(textureLength: Float, textureWidth: Float, textureImage: UIImage!)
    {
        tapedWallSegments.forEach{
            $0.textureWall(textureLength: textureLength, textureWidth: textureWidth, textureImage: textureImage)
            $0.removeGlow(sceneView: sceneView)
        }
    }
}

class WallChainsSet {
    
    var sceneView: ARSCNView
    var center: CGPoint!
    var wallChains = [WallChain]()
    var curentPointer:SCNNode!
    var pointerScene:SCNScene!
    var pointerNode:SCNNode!
    
    private var activePointers:[SCNNode]!
    
    init(sceneView: ARSCNView) {
        
        self.sceneView = sceneView
        
        self.center = sceneView.center
        
        self.pointerScene = SCNScene(named: "assets.scnassets/pointer.scn")
        self.pointerNode = self.pointerScene?.rootNode.childNode(withName: "pointer", recursively: false)
        
        
    }
    
    func addPointer() {
        let newPointerNode = pointerNode.clone()
        let results = sceneView.hitTest(center, types: [.existingPlaneUsingGeometry, .estimatedVerticalPlane, .estimatedHorizontalPlane])
        guard let transform = results.first?.worldTransform else {return}
        newPointerNode.simdTransform = transform
        DispatchQueue.main.async {
            self.sceneView.scene.rootNode.addChildNode(newPointerNode)
        }
        curentPointer = newPointerNode
        if (activePointers != nil)
        {
            activePointers.append(newPointerNode)
        }
        else
        {
            activePointers = [SCNNode]()
            activePointers.append(newPointerNode)
        }
    }
    
    func addChainSet() {
        guard let pointers = activePointers else {return}
        if(pointers.count < 2)
        {
            return
        }
        let wallChain = WallChain()
        wallChain.sceneView = sceneView
        for item in activePointers.dropLast()
        {
            wallChain.points.append(item.position)
        }
        wallChains.append(wallChain)
        wallChain.buildWalls()
        curentPointer.removeFromParentNode()
        activePointers = nil
        curentPointer = nil
    }
    
    func textureWalls(textureLength: Float, textureWidth: Float, textureImage: UIImage!)
    {
        wallChains.forEach{
            $0.textureTapedNode(textureLength: textureLength, textureWidth: textureWidth, textureImage: textureImage)
            $0.tapedWallSegments.removeAll()
        }
    }
}
