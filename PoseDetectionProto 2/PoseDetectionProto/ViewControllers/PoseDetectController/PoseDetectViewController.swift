//
//  PoseDetectViewController.swift
//  PoseDetectionProto
//
//  Created by 정은서 on 2021/11/24.
//

import UIKit
import Vision
import CoreMedia
import os.signpost

class PoseDetectViewController : UIViewController {
    
    var exerKind: String!
    
    public typealias DetectObjectsCompletion = ([PredictedPoint?]?, Error?) -> Void

    // MARK: - UI Properties
    
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var jointView: DrawingJointView!
    @IBOutlet weak var labelsTableView: UITableView!
    
    @IBOutlet weak var inferenceLabel: UILabel!
    @IBOutlet weak var etimeLabel: UILabel!
    @IBOutlet weak var fpsLabel: UILabel!
    
    // MARK: - Performance Measurement Property
    private let 👨‍🔧 = 📏()
    var isInferencing = false
    var infercounting = true
    
    // MARK: - AV Property
    var videoCapture: VideoCapture!
    
    // MARK: - ML Properties
    // Core ML model
    typealias EstimationModel = model_cpm
    
    // Preprecess and Inference
    var request: VNCoreMLRequest?
    var visionModel: VNCoreMLModel?
    
    // Postprocess
    var postProcessor: HeatmapPostProcessor = HeatmapPostProcessor()
    var mvfilters: [MovingAverageFilter] = []
    
    // Inference Result Data
    private var tableData: [PredictedPoint?] = []
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toResultViewButton()
        
        setUpModel()
        
        setUpCamera()
        
        labelsTableView.dataSource = self
        
        👨‍🔧.delegate = self
    }
   
    // MARK: 버튼 체크용
    func checkingView(){
        let label = UILabel(frame: CGRect(x: view.frame.width*0.2, y: view.frame.height*0.3, width: view.frame.width * 0.5, height: view.frame.height * 0.2))
        label.text = exerKind
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Apple Color Emoji", size: 35)
        label.backgroundColor = .blue
        view.addSubview(label)
        print(exerKind)
    }
    
    // MARK: SelectView로 넘어가기
    
    func toResultViewButton(){
        let button = UIButton(frame: CGRect(x: view.frame.width*0.35,
                                            y: view.frame.height*0.8,
                                            width: view.frame.width*0.3,
                                            height: view.frame.height*0.1))
        button.setTitle("Result", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.backgroundColor = .red
        button.alpha = 0.7
        button.addTarget(self, action: #selector(toResultView), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
    }
    
    @objc func toResultView(_ sender: Any){
        self.performSegue(withIdentifier: "ResultViewSegue", sender: nil)
        print("here")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    
    // MARK: - Setup Core ML
    func setUpModel(){
        if let visionModel = try? VNCoreMLModel(for: EstimationModel().model){
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .scaleFill
        }else{
            fatalError("cannot load the ml model")
        }
    }
    
    // MARK: - SetUp Video
    func setUpCamera(){
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .vga640x480) {success in
            if success {
                if let previewLayer = self.videoCapture.previewLayer {
                    DispatchQueue.main.async {
                        self.videoPreview.layer.addSublayer(previewLayer)
                        self.resizePreviewLayer()
                    }
                }
                
                self.videoCapture.start()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer(){
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }

}

// MARK: - VideoCaptureDelegate
extension PoseDetectViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer, timestamp: CMTime) {
        // the captured image from camera is contained on pixelBuffer
        if !isInferencing {
            
            isInferencing = true
            
            // start of measure
            self.👨‍🔧.🎬👏()
            
            // predict!
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
        
    }
}

extension PoseDetectViewController {
    // MARK: - Inferencing
    func predictUsingVision(pixelBuffer: CVPixelBuffer){
        guard let request = request else {fatalError()}
        
        // vision framework configures the input size of image following our model's input configuration automatically
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        
//        if #available(iOS 12.0, *) {
//            os_signpost(.begin, log: refreshing, name: "PoseEstimation")
//        }
        try? handler.perform([request])
        
    }
    
    // MARK: - PostProcessing
    func visionRequestDidComplete(request: VNRequest, error: Error?){
        //        if #available(iOS 12.0, *) {
        //            os_signpost(.begin, log: refreshing, name: "PoseEstimation")
        //        }
        
        self.👨‍🔧.🏷(with: "endInference")
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
           
           let heatmaps = observations.first?.featureValue.multiArrayValue {
           
            /* ========================================================================= */
            /* =========================== post-processing ============================= */
        
            if infercounting {
                print("heatmaps: \(heatmaps)")
                infercounting = false
             }
            /* ------------------ convert heatmap to point array ----------------- */
            var predictedPoints = postProcessor.convertToPredictedPoints(from: heatmaps)

            /* --------------------- moving average filter ----------------------- */
            if predictedPoints.count != mvfilters.count {
                mvfilters = predictedPoints.map { _ in MovingAverageFilter(limit: 3) }
            }
            for (predictedPoint, filter) in zip(predictedPoints, mvfilters) {
                filter.add(element: predictedPoint)
            }
            predictedPoints = mvfilters.map { $0.averagedValue() }
            /* =================================================================== */

            /* =================================================================== */
            /* ======================= display the results ======================= */
            DispatchQueue.main.sync {
                // draw line
                self.jointView.bodyPoints = predictedPoints

                // show key points description
                self.showKeypointsDescription(with: predictedPoints)

                // end of measure
                self.👨‍🔧.🎬🤚()
                self.isInferencing = false
                
//                if #available(iOS 12.0, *) {
//                    os_signpost(.end, log: refreshLog, name: "PoseEstimation")
//                }
            }
            /* =================================================================== */
        } else {
            // end of measure
            self.👨‍🔧.🎬🤚()
            self.isInferencing = false
            
//            if #available(iOS 12.0, *) {
//                os_signpost(.end, log: refreshLog, name: "PoseEstimation")
//            }
        }
    }
    
    func showKeypointsDescription(with n_kpoints: [PredictedPoint?]) {
        self.tableData = n_kpoints
        self.labelsTableView.reloadData()
    }
}

// MARK: - UITableView Data Source
extension PoseDetectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count// > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = PoseEstimationForMobileConstant.pointLabels[indexPath.row]
        if let body_point = tableData[indexPath.row] {
            let pointText: String = "\(String(format: "%.3f", body_point.maxPoint.x)), \(String(format: "%.3f", body_point.maxPoint.y))"
            cell.detailTextLabel?.text = "(\(pointText)), [\(String(format: "%.3f", body_point.maxConfidence))]"
        } else {
            cell.detailTextLabel?.text = "N/A"
        }
        return cell
    }
}

// MARK: - 📏(Performance Measurement) Delegate
extension PoseDetectViewController: 📏Delegate {
    func updateMeasure(inferenceTime: Double, executionTime: Double, fps: Int) {
        self.inferenceLabel.text = "inference: \(Int(inferenceTime*1000.0)) ms"
        self.etimeLabel.text = "execution: \(Int(executionTime*1000.0)) ms"
        self.fpsLabel.text = "fps: \(fps)"
    }
}
