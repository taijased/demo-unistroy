//
//  ViewController.swift
//  demo-uni

//  Created by Tim Zagirov on 08/03/2019.
//  Copyright © 2019 Tim Zagirov. All rights reserved.


import UIKit
import ARKit
import UserNotifications
import ZIPFoundation
import SceneKit.ModelIO
import AssetImportKit
import Alamofire

class ViewController: UIViewController, ARSCNViewDelegate {
    

    
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    ////////DOWNLOAD
//    @IBAction func downloadButton(_ sender: Any) {
//        showAlert()
//        dataProvider.startDownload()
        ///////Чиста для тестов тут

//        let sofaScene = SCNScene(named: "assets.scnassets/sofa/Sofa.scn")
//        let furnitureNode = Furniture()
//        furnitureNode.name = "sofa"
//        sofaScene?.rootNode.childNodes.forEach{
//            furnitureNode.addChildNode($0)
//        }
//        sceneView.scene.rootNode.addChildNode(furnitureNode)
//
//    }
//    @IBAction func unzipButton(_ sender: Any) {
////                   unzipFile()
//
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//
//        let pathToObject = documentDirectory + "/dodge/kakoyta_fail.fbx" //"/sofa/Sofa1.DAE" //"ship/ship.scn"
//        //С сцн все работает заебись
//
////        let fileUrl = URL(fileURLWithPath: pathToObject)
//
//
//        let scaleFactor:Float = 0.0025
//
//        do {
////            let assimpScene = try SCNScene.assimpScene(filePath: pathToObject, postProcessSteps: [.optimizeGraph, .optimizeMeshes]) //для дае
//            let assimpScene = try SCNScene.assimpScene(filePath: pathToObject, postProcessSteps: [.defaultQuality])
//            let modelScene = assimpScene.modelScene
//            modelScene.rootNode.childNodes.forEach {
//                $0.position =   $0.position * scaleFactor
//                $0.scale = $0.scale * scaleFactor
//                sceneView.scene.rootNode.addChildNode($0)
//
//            }
//
//
//        }
//        catch
//        {
//
//        }
//
//
//        //Тут я пытался посмотреть пути к папкам и что в них хранится
//        //Пути посмотреть получилось, контент папок нет
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//        do {
//            // Get the directory contents urls (including subfolders urls)
//            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
//            print("//////////////CONTENT")
//            print(directoryContents)
//            print("//////////////CONTENT")
//            print("//////////////CONTENT_________IN___FOLDERS")
//            for item in directoryContents {
//                print(try FileManager.default.contentsOfDirectory(atPath: item.absoluteString))
//            }
//            print("//////////////CONTENT_________IN___FOLDERS")
//
//        } catch {
//            print("huiii")
//        }
//
//        wallChainsSet.textureWalls(textureLength: 1, textureWidth: 1, textureImage: UIImage(named: "assets.scnassets/images/img2.jpg"))
//    }
//    @IBOutlet weak var unzipOutlet: UIButton!{
//        didSet {
            //            unzipOutlet.isHidden = true
            
//        }
//    }
    ////////
    
    
    enum CatalogState {
        case expanded
        case collapsed
    }
    
    var catalogViewController: CatalogViewController!
    var visualEffectView: UIVisualEffectView!
    
    var catalogHeight:CGFloat = 520
    let catalogHandleAreaHeight:CGFloat = 65
    
    
    
    var catalogVisible = false
    var nextState:CatalogState {
        return catalogVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    var isWallTapped = false
    
    @IBAction func doneScene(_ sender: Any) {
        if(isWallTapped) {
            catalogViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - catalogHandleAreaHeight, width: self.view.bounds.width, height: catalogHeight)
            
        }
        else
        {
            wallChainsSet.addChainSet()
            isWallTapped = true
        }
    }
    
    
    
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    lazy var interactions = ARInteractions(sceneView: sceneView)
    lazy var wallChainsSet = WallChainsSet(sceneView: sceneView)
    var buildingInProgress = true
    var planeAnchore:ARPlaneAnchor!
    var isPlaneDetected = false
    
    
    /////////////////DOWNLOAD
    private var alert: UIAlertController!
    private let dataProvider = DataProvider()
    private var filePath: String?
    private var fileSavePath: URL?
    
    
    @IBAction func downloadTap(_ sender: UIButton) {
        showAlert()
        dataProvider.startDownload()
    }
    
    ////////////////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupCatalog()
        //        setupConstraintButton()
        let configuration = ARWorldTrackingConfiguration();
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration);
        self.sceneView.autoenablesDefaultLighting = true
        sceneView.delegate = self
        
        
        /////////DOWNLOAD
        registerForNotification()
        
        dataProvider.fileLocation = { (location) in
            
            // Сохранить файл для дальнейшего использования
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false, completion: nil)
            self.postNotification()
        }
        /////////
        
        
    }
    
    @IBAction func plusButton(_ sender: Any) {
        catalogViewController.view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        wallChainsSet.addPointer()
        isWallTapped = false
    }
    
    @IBAction func continueButton(_ sender: Any) {
       wallChainsSet.addChainSet()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        interactions.trackObject(node: wallChainsSet.curentPointer)
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if(!isPlaneDetected) {
            guard anchor is ARPlaneAnchor else {return}
            interactions.planeAnchor = (anchor as! ARPlaneAnchor)
            isPlaneDetected = true
            wallChainsSet.addPointer()
        }
    }
    
    
    
    
    func setupCatalog() {
        //        visualEffectView = UIVisualEffectView()
        //        visualEffectView.frame = self.view.frame
        //        self.view.addSubview(visualEffectView)
        
        catalogViewController = CatalogViewController(nibName:"CatalogViewController", bundle:nil)
        catalogViewController.onSelectFurniture = { furniture in
            self.selectFurniture(furniture: furniture)
        }
        catalogViewController.onSelectTexture = { texture in
            self.selectTexture(texture: texture)
        }
        
        self.addChild(catalogViewController)
        self.view.addSubview(catalogViewController.view)
        
        catalogViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - catalogHandleAreaHeight, width: self.view.bounds.width, height: catalogHeight)
        
        //        catalogViewController.view.layer.shadowColor = UIColor.black.cgColor
        //        catalogViewController.view.layer.shadowOpacity = 1
        //        catalogViewController.view.layer.shadowOffset = CGSize(width: 0, height: 2)
        //        catalogViewController.view.layer.shadowRadius = 10
        
        
        
        self.catalogViewController.view.layer.cornerRadius = 12
        catalogViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan))
        
        catalogViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        catalogViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
        
    }
    private func selectTexture(texture: CardModel) {
        wallChainsSet.textureWalls(textureLength: 1, textureWidth: 1, textureImage: UIImage(named: texture.modelPath))
    }
    private func selectFurniture(furniture: CardModel) {
        
        let hitTest = sceneView!.hitTest(sceneView.center, types: .existingPlane)
        let result = hitTest.last
        guard let transform = result?.worldTransform else {return}
        let thirdColumn = transform.columns.3
        
        let sofaScene = SCNScene(named: furniture.modelPath)
        let furnitureNode = Furniture()
        furnitureNode.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        furnitureNode.name = furniture.cardName
        sofaScene?.rootNode.childNodes.forEach{
            furnitureNode.addChildNode($0)
        }
        self.sceneView.scene.rootNode.addChildNode(furnitureNode)
    }
    
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.catalogViewController.handleArea)
            var fractionComplete = translation.y / catalogHeight
            fractionComplete = catalogVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded (state: CatalogState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.catalogViewController.view.frame.origin.y = self.view.frame.height - self.catalogHeight
                case .collapsed:
                    self.catalogViewController.view.frame.origin.y = self.view.frame.height - self.catalogHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.catalogVisible = !self.catalogVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.catalogViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.catalogViewController.view.layer.cornerRadius = 12
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            //            блокирует кнопки эти эффекты хуй знает почему
            //            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            //                switch state {
            //                case .expanded:
            //                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
            //                case .collapsed:
            //                    self.visualEffectView.effect = nil
            //                }
            //            }
            //
            //            blurAnimator.startAnimation()
            //            runningAnimations.append(blurAnimator)
            
        }
    }
    
    func startInteractiveTransition(state: CatalogState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    
    //    button custom
    
    func setupConstraintButton() {
        
        print("setupConstraintButton")
        
        //        huemouo
        //        addButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        //        addButtonOutlet.centerXAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //        addButtonOutlet.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //        addButtonOutlet.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //        addButtonOutlet.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    /////////DOWNLOAD    
    private func unzipFile() {
        
        let fileManager = FileManager()
        
        var separatorPath = filePath!.components(separatedBy: "/")
        let directoryName = separatorPath[separatorPath.count - 1].components(separatedBy: ".")[0]
        let fileName = separatorPath[separatorPath.count - 1]
        separatorPath.remove(at: separatorPath.count - 1)
        
        let currentWorkingPath = String(separatorPath.joined(separator: "/"))
        
        
        var sourceURL = URL(fileURLWithPath: currentWorkingPath)
        sourceURL.appendPathComponent(fileName)
        
        var destinationURL = URL(fileURLWithPath: currentWorkingPath)
        destinationURL.appendPathComponent(directoryName)
        
        
        do {
            try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
            try fileManager.unzipItem(at: sourceURL, to: destinationURL)
            
            self.postNotification(path: destinationURL.absoluteString, fileName: fileName)
            self.fileSavePath = destinationURL
            
        } catch {
            print("Extraction of ZIP archive failed with error:\(error.localizedDescription)")
        }
        
        
    }
    
    private func showAlert() {
        
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        
        let height = NSLayoutConstraint(item: alert.view,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 0,
                                        constant: 170)
        
        alert.view.addConstraint(height)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
            self.dataProvider.stopDownload()
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true) {
            
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2,
                                y: self.alert.view.frame.height / 2 - size.height / 2)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0,
                                                            y: self.alert.view.frame.height - 44,
                                                            width: self.alert.view.frame.width,
                                                            height: 2))
            progressView.tintColor = .blue
            
            self.dataProvider.onProgress = { (progress) in
                
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }
    
    
}

//////////DOWNLOAD


extension ViewController {
    
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
            
        }
    }
    
    private func postNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your background transfer has completed. File path: \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func postNotification(path: String, fileName: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Unzip complete!"
        content.body = "Unzip file \(fileName). Files path: \(path)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

