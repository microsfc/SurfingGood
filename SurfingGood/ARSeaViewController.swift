//
//  ARSeaViewController.swift
//  SurfingGood
//
//  Created by liusean on 18/09/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit
import ARKit

class ARSeaViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBox()
        addTapGestureToSceneView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(x, y, z)
        
        //        let scene = SCNScene()
        //        scene.rootNode.addChildNode(boxNode)
        //        sceneView.scene = scene
        
        sceneView.scene.rootNode.addChildNode(boxNode)
        
    }
    
    func addText(text: NSString, x: Float = 0, y: Float = 0, z: Float = -0.2) {
//        let showText = SCNText(string: text, extrusionDepth: 5.0)
//        var x = 0.0
//        var delta = 0.0
//        showText.firstMaterial?.diffuse.contents = UIColor.orange
//        showText.firstMaterial?.specular.contents = UIColor.orange
//        showText.font = UIFont(name: "Optima", size: 44)
//        showText.containerFrame = CGRect(x: 0, y: 0, width: 100, height: 44)
//        x += 0.12
//        delta += 0.12
        
//        let textNode = SCNNode(geometry: showText)
//        textNode.position = SCNVector3(-0.2 + x, -0.9 + delta, -1)
        
        
        let textGeometry = SCNText(string: "Hello World", extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.black
        
        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(0,0.1,-1)
        textNode.scale = SCNVector3(0.5,0.5,0.5)
        
        // self.node.addChildNode(boxNode)
        sceneView.scene.rootNode.addChildNode(textNode)  // this never displays the text node
    }
    
    func addTapGestureToSceneView() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
//                addText(text: "AR Text", x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension float4x4 {
    
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
    
}
