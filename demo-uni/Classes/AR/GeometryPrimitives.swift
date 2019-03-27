//
//  GeometryPrimitives.swift
//  demo-uni
//
//  Created by Alexey Antipin on 09/03/2019.
//  Copyright © 2019 Tim Zagirov. All rights reserved.
//

import Foundation
import ARKit

class GeometryPrimitives {
    class func createPlane(_ width: CGFloat, _ height: CGFloat, _ position: SCNVector3, _ eulerAngles: SCNVector3, _ color: UIColor) -> WallSegment
    {
        let plane = SCNPlane(width: 1, height: 1)
        let planeNode = WallSegment()
        planeNode.geometry = plane
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        planeNode.geometry?.firstMaterial?.diffuse.contents = color
        planeNode.eulerAngles = eulerAngles
        planeNode.position = position
        planeNode.scale = SCNVector3(width, height, 1)
        planeNode.name = "wall element"
        return planeNode
    }
}
