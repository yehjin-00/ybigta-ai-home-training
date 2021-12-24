/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The implementation of the application's view controller, responsible for coordinating
 the user interface, video feed, and PoseNet model.
*/

import AVFoundation
import UIKit
import VideoToolbox

class ViewController: UIViewController {
    /// The view the controller uses to visualize the detected poses.
    @IBOutlet private var previewImageView: PoseImageView!

    var exerKind:String!
    var label1: UILabel!
    var label2: UILabel!
    var label3: UILabel!
    var label4: UILabel!
    var label5: UILabel!
    var count = 0
    var progresslabel = "normal"
    var feedlabel = "let's go"
    var starttime : CFAbsoluteTime!
    var currenttime : CFAbsoluteTime!
    var durationtime : Int = 0
    
    private let videoCapture = VideoCapture()

    private var poseNet: PoseNet!

    /// The frame the PoseNet model is currently making pose predictions from.
    private var currentFrame: CGImage?

    /// The algorithm the controller uses to extract poses from the current frame.
    private var algorithm: Algorithm = .multiple

    /// The set of parameters passed to the pose builder when detecting poses.
    private var poseBuilderConfiguration = PoseBuilderConfiguration()

    private var popOverPresentationManager: PopOverPresentationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        Labelgen()
        starttime = CFAbsoluteTimeGetCurrent()

        // For convenience, the idle timer is disabled to prevent the screen from locking.
        UIApplication.shared.isIdleTimerDisabled = true

        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }

        poseNet.delegate = self
        setupAndBeginCapturingVideoFrames()
        
        addFinishButton()
    }
    
    func addFinishButton(){
        let finishButton = UIButton(frame: CGRect(x: view.frame.width * 0.4,
                                              y: view.frame.height * 0.875,
                                              width: view.frame.width * 0.2,
                                              height: view.frame.height * 0.05))
        finishButton.setTitle("종료", for: UIControl.State.normal)
        finishButton.setTitleColor(.white, for: UIControl.State.normal)
        finishButton.backgroundColor = .red
        finishButton.alpha = 0.7
        finishButton.addTarget(self, action: #selector(toResultViewController), for: UIControl.Event.touchUpInside)
        
        
        view.addSubview(finishButton)
    }
    
    @objc func toResultViewController(_ sender: UIButton){
        if exerKind != "CORRECT"{
            performSegue(withIdentifier: "ResultViewSegue", sender: sender)
        } else if exerKind == "CORRECT"{
            performSegue(withIdentifier: "SelectViewSegue2", sender: sender)
        }
    }
    
    
    func Labelgen(){
       
        label1 = UILabel(frame: CGRect(x: view.frame.width * 0.1,
                                      y: view.frame.height * 0.125,
                                      width: view.frame.width * 0.2,
                                      height: view.frame.height * 0.05))
        
        label1.text = String(count)
        label1.font = .boldSystemFont(ofSize: 20)
        label1.textColor = .systemBlue
        label1.backgroundColor = .white.withAlphaComponent(0.8)
        label1.textAlignment = .center
        
        label2 = UILabel(frame: CGRect(x: view.frame.width * 0.2,
                                      y: view.frame.height * 0.8,
                                      width: view.frame.width * 0.6,
                                      height: view.frame.height * 0.05))
        
        label2.text = progresslabel
        label2.font = .boldSystemFont(ofSize: 20)
        label2.textAlignment = .center
        label2.textColor = .systemBlue
        label2.backgroundColor = .white.withAlphaComponent(0.8)
        
        label3 = UILabel(frame: CGRect(x: view.frame.width * 0.1,
                                      y: view.frame.height * 0.75,
                                      width: view.frame.width * 0.6,
                                      height: view.frame.height * 0.05))
        label3.text = feedlabel
        label3.textAlignment = .center
        label3.textColor = .systemBlue
        label3.backgroundColor = .white.withAlphaComponent(0.8)
        
        if exerKind != "CORRECT"{
            view.addSubview(label1)
            view.addSubview(label2)
//            view.addSubview(label3)
        }
        
        label4 = UILabel(frame: CGRect(x: view.frame.width * 0.1,
                                      y: view.frame.height * 0.8,
                                      width: view.frame.width * 0.8,
                                      height: view.frame.height * 0.05))
        label4.text = "진단모드"
        label4.font = .boldSystemFont(ofSize: 20)
        label4.textAlignment = .center
        label4.textColor = .systemBlue
        label4.backgroundColor = .white.withAlphaComponent(0.8)
        
        if exerKind == "CORRECT"{
            view.addSubview(label4)
        }
        
        label5 = UILabel(frame: CGRect(x: view.frame.width * 0.7,
                                      y: view.frame.height * 0.125,
                                      width: view.frame.width * 0.2,
                                      height: view.frame.height * 0.05))
        
        label5.text = String(durationtime)+"초"
        label5.font = .boldSystemFont(ofSize: 20)
        label5.textAlignment = .center
        label5.textColor = .systemBlue
        label5.backgroundColor = .white.withAlphaComponent(0.8)
        
        view.addSubview(label5)
        
    }


    private func setupAndBeginCapturingVideoFrames() {
        videoCapture.setUpAVCapture { error in
            if let error = error {
                print("Failed to setup camera with error \(error)")
                return
            }

            self.videoCapture.delegate = self

            self.videoCapture.startCapturing()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        videoCapture.stopCapturing {
            super.viewWillDisappear(animated)
        }
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        // Reinitilize the camera to update its output stream with the new orientation.
        setupAndBeginCapturingVideoFrames()
    }

    @IBAction func onCameraButtonTapped(_ sender: Any) {
        videoCapture.flipCamera { error in
            if let error = error {
                print("Failed to flip camera with error \(error)")
            }
        }
    }

    @IBAction func onAlgorithmSegmentValueChanged(_ sender: UISegmentedControl) {
        guard let selectedAlgorithm = Algorithm(
            rawValue: sender.selectedSegmentIndex) else {
                return
        }

        algorithm = selectedAlgorithm
    }
}

// MARK: - Navigation

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultViewSegue" {
            if let vc = segue.destination as? ResultViewController {
                
                vc.time = durationtime
                vc.count = label1.text
                vc.exerKind = exerKind
            }
        }
        
        guard let uiNavigationController = segue.destination as? UINavigationController else {
            return
        }
        guard let configurationViewController = uiNavigationController.viewControllers.first
            as? ConfigurationViewController else {
                    return
        }

        configurationViewController.configuration = poseBuilderConfiguration
        configurationViewController.algorithm = algorithm
        configurationViewController.delegate = self

        popOverPresentationManager = PopOverPresentationManager(presenting: self,
                                                                presented: uiNavigationController)
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = popOverPresentationManager
        
        
    }
}

// MARK: - ConfigurationViewControllerDelegate

extension ViewController: ConfigurationViewControllerDelegate {
    func configurationViewController(_ viewController: ConfigurationViewController,
                                     didUpdateConfiguration configuration: PoseBuilderConfiguration) {
        poseBuilderConfiguration = configuration
    }

    func configurationViewController(_ viewController: ConfigurationViewController,
                                     didUpdateAlgorithm algorithm: Algorithm) {
        self.algorithm = algorithm
    }
}

// MARK: - VideoCaptureDelegate

extension ViewController: VideoCaptureDelegate {
    func videoCapture(_ videoCapture: VideoCapture, didCaptureFrame capturedImage: CGImage?) {
        guard currentFrame == nil else {
            return
        }
        guard let image = capturedImage else {
            fatalError("Captured image is null")
        }

        currentFrame = image
        poseNet.predict(image)
    }
}

// MARK: - PoseNetDelegate

extension ViewController: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer {
            // Release `currentFrame` when exiting this method.
            self.currentFrame = nil
        }

        guard let currentFrame = currentFrame else {
            return
        }

        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: poseBuilderConfiguration,
                                      inputImage: currentFrame, label4: label4)

        if #available(iOS 15, *) {
            
            let poses = algorithm == .single
            ? [poseBuilder.pose]
            : poseBuilder.poses
            currenttime = CFAbsoluteTimeGetCurrent()
            durationtime = Int(currenttime - starttime)
            label5.text = String(durationtime) + "초"
            previewImageView.show(poses: poses, on: currentFrame, exer: exerKind, label1: label1, label2: label2, label3: label3 )
        } else {
            fatalError()
            // Fallback on earlier versions
        }

        
    }
}
