//
//  ViewController.swift
//  ARApp
//
//  Created by James Rochabrun on 6/26/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // setting plane detetction horizontal
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

// MARK: ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    
    /// This is a delegate method and is called when a horizontal plane is detected.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // 1 - check if anchor is PlaneAnchor, anchors can be of many type
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // 2 - create a shape, plane geometry with the help of dimentions we got from planeAnchor
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        // 3 - provide coordinates
        /// 3.1 a node is basically a position
        let planeNode = SCNNode()
        
        /// 3.2 setting the position of the plane geometry to the position we got using the plane anhor
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        /// 3.3 when a plane is created its created in XY plane instead of XZ plane, so we need to rotate it along X axis
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        // 4 - Customize the materials
        
        /// 4.1 - Create a material object
        let gridMaterial = SCNMaterial()
        
        /// 4.2 - setting the material as an image. A material can also be set to a color
        gridMaterial.diffuse.contents = UIImage.init(named: "grid.png")
        
        /// 4.3 - assigning the material to the plane
        plane.materials = [gridMaterial]
    }
}
