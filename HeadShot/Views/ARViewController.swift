import ARKit
import SceneKit
import UIKit

/// Size of the generated face texture
private let faceTextureSize = 1024 //px

/// Should the face mesh be filled in? (i.e. fill in the eye and mouth holes with geometry)
private let fillMesh = true

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    private var faceUvGenerator: FaceTextureGenerator!
    private var scnFaceGeometry: ARSCNFaceGeometry!
    
    // MARK: AR View
    
    /// Primary AR view
    private var sceneView: ARSCNView!
    
    // MARK: Preview scene
    
    /// Secondary scene view that shows the captured face
    private var previewSceneView: SCNView!
    private var previewFaceNode: SCNNode!
    private var previewFaceGeometry: ARSCNFaceGeometry!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: self.view.bounds, options: nil)
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = false
        sceneView.rendersCameraGrain = true
        self.view.addSubview(sceneView)
        
        self.scnFaceGeometry = ARSCNFaceGeometry(device: self.sceneView.device!, fillMesh: fillMesh)
        
        self.faceUvGenerator = FaceTextureGenerator(
            device: self.sceneView.device!,
            library: self.sceneView.device!.makeDefaultLibrary()!,
            viewportSize: self.view.bounds.size,
            face: self.scnFaceGeometry!,
            textureSize: faceTextureSize)
        
        // Preview
        previewSceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), options: nil)
        previewSceneView.rendersContinuously = true
        previewSceneView.backgroundColor = UIColor.black
        previewSceneView.allowsCameraControl = true
        self.view.addSubview(previewSceneView)
        previewSceneView.scene = SCNScene()
        
        let camera = SCNCamera()
        camera.zNear = 0.001
        camera.zFar = 1000
        
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(0, 0, 1)
        previewSceneView.scene!.rootNode.addChildNode(cameraNode)
        cameraNode.look(at: SCNVector3Zero)
        
        self.previewFaceGeometry = ARSCNFaceGeometry(device: self.sceneView.device!, fillMesh: true)
        self.previewFaceNode = SCNNode(geometry: self.previewFaceGeometry)
        let faceScale = Float(4.0)
        self.previewFaceNode.scale = SCNVector3(x: faceScale, y: faceScale, z: faceScale)
        self.previewFaceGeometry.firstMaterial!.diffuse.contents = faceUvGenerator.texture
        self.previewFaceGeometry.firstMaterial!.isDoubleSided = true

        previewSceneView.scene!.rootNode.addChildNode(self.previewFaceNode!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resetTracking()
    }
    
    // MARK: AR
    
    private func resetTracking() {
        sceneView.session.run(ARFaceTrackingConfiguration(),
                              options: [.removeExistingAnchors,
                                        .resetTracking,
                                        .resetSceneReconstruction,
                                        .stopTrackedRaycasts])
    }
    
    public func renderer(_: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else {
            return nil
        }
                
        return SCNNode()
    }
     
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let frame = sceneView.session.currentFrame
        else {
            return
        }
        
        self.previewFaceGeometry.update(from: faceAnchor.geometry)

        scnFaceGeometry.update(from: faceAnchor.geometry)
        faceUvGenerator.update(frame: frame, scene: self.sceneView.scene, headNode: node, geometry: scnFaceGeometry)
    }
}
