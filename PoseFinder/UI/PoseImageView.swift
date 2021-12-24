/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation details of a view that visualizes the detected poses.
*/

import UIKit

@IBDesignable
class PoseImageView: UIImageView {

    var count = 0
    var progresslabel = "normal"
    var feedlabel = "let's go"
    var feedlabelview : UILabel!
    
    
    var nose : Joint!
    var lefteye : Joint!
    var righteye : Joint!
    var leftear : Joint!
    var rightear : Joint!
    var leftshoulder : Joint!
    var rightshoulder : Joint!
    var leftelbow : Joint!
    var rightelbow : Joint!
    var leftwrist : Joint!
    var rightwrist : Joint!
    var lefthip : Joint!
    var righthip : Joint!
    var leftknee : Joint!
    var rightknee : Joint!
    var leftankle : Joint!
    var rightankle : Joint!
    
//    var label: UILabel!
    /// A data structure used to describe a visual connection between two joints.
    struct JointSegment {
        let jointA: Joint.Name
        let jointB: Joint.Name
    }

    /// An array of joint-pairs that define the lines of a pose's wireframe drawing.
    static let jointSegments = [
        // The connected joints that are on the left side of the body.
        JointSegment(jointA: .leftHip, jointB: .leftShoulder),
        JointSegment(jointA: .leftShoulder, jointB: .leftElbow),
        JointSegment(jointA: .leftElbow, jointB: .leftWrist),
        JointSegment(jointA: .leftHip, jointB: .leftKnee),
        JointSegment(jointA: .leftKnee, jointB: .leftAnkle),
        // The connected joints that are on the right side of the body.
        JointSegment(jointA: .rightHip, jointB: .rightShoulder),
        JointSegment(jointA: .rightShoulder, jointB: .rightElbow),
        JointSegment(jointA: .rightElbow, jointB: .rightWrist),
        JointSegment(jointA: .rightHip, jointB: .rightKnee),
        JointSegment(jointA: .rightKnee, jointB: .rightAnkle),
        // The connected joints that cross over the body.
        JointSegment(jointA: .leftShoulder, jointB: .rightShoulder),
        JointSegment(jointA: .leftHip, jointB: .rightHip)
    ]

    /// The width of the line connecting two joints.
    @IBInspectable var segmentLineWidth: CGFloat = 2
    /// The color of the line connecting two joints.
    @IBInspectable var segmentColor: UIColor = UIColor.systemTeal
    /// The radius of the circles drawn for each joint.
    @IBInspectable var jointRadius: CGFloat = 4
    /// The color of the circles drawn for each joint.
    @IBInspectable var jointColor: UIColor = UIColor.systemPink

    // MARK: - Rendering methods

    /// Returns an image showing the detected poses.
    ///
    /// - parameters:
    ///     - poses: An array of detected poses.
    ///     - frame: The image used to detect the poses and used as the background for the returned image.
    func show(poses: [Pose], on frame: CGImage, exer: String, label1: UILabel, label2: UILabel, label3: UILabel){
        //print("term")
        //print(poses)
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        feedlabelview = label3
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,
                                               format: dstImageFormat)

        let dstImage = renderer.image { rendererContext in
            // Draw the current frame as the background for the new image.
//            print("frame: \(frame.width), \(frame.height)")
            draw(image: frame, in: rendererContext.cgContext)

            for pose in poses {
                // Draw the segment lines.
                nose = pose.joints[.nose]
                lefteye = pose.joints[.leftEye]
                righteye = pose.joints[.rightEye]
                leftear = pose.joints[.leftEar]
                rightear = pose.joints[.rightEar]
                leftshoulder = pose.joints[.leftShoulder]
                rightshoulder = pose.joints[.rightShoulder]
                leftelbow = pose.joints[.leftElbow]
                rightelbow = pose.joints[.rightElbow]
                leftwrist = pose.joints[.leftWrist]
                rightwrist = pose.joints[.rightWrist]
                lefthip = pose.joints[.leftHip]
                righthip = pose.joints[.rightHip]
                leftknee = pose.joints[.leftKnee]
                rightknee = pose.joints[.rightKnee]
                leftankle = pose.joints[.leftAnkle]
                rightankle = pose.joints[.rightAnkle]
                
                for segment in PoseImageView.jointSegments {
                    let jointA = pose[segment.jointA]
                    let jointB = pose[segment.jointB]

                    guard jointA.isValid, jointB.isValid else {
                        continue
                    }

                    drawLine(from: jointA,
                             to: jointB,
                             in: rendererContext.cgContext)
                
                }

                // Draw the joints as circles above the segment lines.
                for joint in pose.joints.values.filter({ $0.isValid }) {
                    draw(circle: joint, in: rendererContext.cgContext)
                }
                
                countExercise(exer: exer, pose: pose)
                label1.text = String(count)
                label2.text = progresslabel
                
                
                
            }
        }
        
        

        image = dstImage
    }
    
    func countExercise(exer: String, pose: Pose) {
        if(exer=="SQUAT"){
            if readyform(exer: exer, pose: pose) {
                if progresslabel == "motioning"{
                    count = count + 1
                }
                
                progresslabel = "ready"
                
            }else if exerform(exer: exer, pose: pose){
                progresslabel = "motioning"
            }
        }else if(exer == "PUSHUP"){
            if readyform(exer: exer, pose: pose) {
                if progresslabel == "motioning"{
                    count = count + 1
                }
                
                progresslabel = "ready"
                
            }else if exerform(exer: exer, pose: pose){
                progresslabel = "motioning"
            }
        }else if(exer == "LUNGE"){
            if readyform(exer: exer, pose: pose) {
                if progresslabel == "motioningRight"{
                    progresslabel = "ready_Right"
                    count = count + 1
                } else if progresslabel == "motioningLeft" {
                    progresslabel = "ready_Left"
                    count = count + 1
                }
                
            }else if exerform(exer: exer, pose: pose){
                
            }
        }else if(exer == "PLANK"){
            
        }else if(exer == "SIDE"){
            if readyform(exer: exer, pose: pose){
                if progresslabel == "motioningRight"{
                    progresslabel = "ready"
                    count = count + 1
                } else if progresslabel == "motioningLeft" {
                    progresslabel = "ready_Left"
                }
                
            }else if exerform(exer: exer, pose: pose){
                
            }
        }else if(exer == "SITUP"){
            
        }
        globalcount = count
        globalFeed = progresslabel
    }
    
    func readyform(exer: String, pose: Pose) -> Bool {
        // right-Shoulder-Hip-Knee angle
        if(exer=="SQUAT"){
          
            let RSHK = angle(firstLandmark: rightshoulder, midLandmark: righthip, lastLandmark: rightknee )
            let LSHK = angle(firstLandmark: leftshoulder, midLandmark: lefthip, lastLandmark: leftknee )
            if(RSHK>=160 && LSHK>=160){
                print("SQUAT ready ok")
                feedlabel = "Great"
                feedlabelview.text = feedlabel
                return true
//            } else if (RSHK>=160&&LSHK<100){
//                feedlabel = "stretch left leg more"
//                feedlabelview.text = feedlabel
//            }else if (RSHK<100&&LSHK>=160){
//                feedlabel = "stretch right leg more"
//                feedlabelview.text = feedlabel
            }else{
                //print("no")
                return false
            }
        
        }else if (exer=="PUSHUP"){
          
            let RWES = angle(firstLandmark: rightwrist, midLandmark: rightwrist, lastLandmark: rightshoulder)
            let RSHK = angle(firstLandmark: rightshoulder, midLandmark: righthip, lastLandmark: rightknee )
            let RHKA = angle(firstLandmark: righthip, midLandmark: rightknee, lastLandmark: rightankle)
            let RESH = angle(firstLandmark: rightelbow, midLandmark: rightshoulder, lastLandmark: righthip)
            
            let LWES = angle(firstLandmark: leftwrist, midLandmark: leftwrist, lastLandmark: leftshoulder)
            let LSHK = angle(firstLandmark: leftshoulder, midLandmark: lefthip, lastLandmark: leftknee )
            let LHKA = angle(firstLandmark: lefthip, midLandmark: leftknee, lastLandmark: leftankle)
            let LESH = angle(firstLandmark: leftelbow, midLandmark: leftshoulder, lastLandmark: lefthip)
            
            if((RWES>=165 && RSHK>=155 && RHKA >= 165 && RESH >= 70 && RESH <= 100) || (LWES>=165 && LSHK>=155 && LHKA >= 165 && LESH >= 70 && LESH <= 100)){
                //print("PUSHUP ready ok")
                return true

            }else{
                //print("no")
                return false
            }
            
        }else if(exer == "LUNGE"){
        
            let RSHK = angle(firstLandmark: rightshoulder, midLandmark: righthip, lastLandmark: rightknee )
            let RHKA = angle(firstLandmark: righthip, midLandmark: rightknee, lastLandmark: rightankle)
            let LSHK = angle(firstLandmark: leftshoulder, midLandmark: lefthip, lastLandmark: leftknee )
            let LHKA = angle(firstLandmark: lefthip, midLandmark: leftknee, lastLandmark: leftankle)
            if((RHKA >= 130 && LSHK >= 150 && LHKA >= 120)){
                print("LUNGE right exer ok")
                return true
            }else if ((LHKA >= 130 && RSHK >= 150 && RHKA >= 120)){
                print("LUNGE left exer ok")
                return true
            }else{
                print("no")
                return false
            }
                
            
        }else if(exer == "SIDE"){
            let LSHK = angle(firstLandmark: leftshoulder, midLandmark: lefthip, lastLandmark: leftknee)
            let RSHK = angle(firstLandmark: rightshoulder, midLandmark: righthip, lastLandmark: rightknee)
            
            if(LSHK >= 150 && RSHK >= 150){

                return true
            }
              
        }else if(exer == "SITUP"){
            
        }
        
        
        return false
        
    }
    
    func exerform(exer: String, pose: Pose) -> Bool {
        
        if (exer == "SQUAT"){
            let RSHK = angle(firstLandmark: rightshoulder, midLandmark: righthip, lastLandmark: rightknee )
            let LSHK = angle(firstLandmark: leftshoulder, midLandmark: lefthip, lastLandmark: leftknee )
            if(45<=RSHK&&RSHK<=140 && 45<=LSHK&&LSHK<=140){
                //print("RSHK exer ok")
                feedlabel = "Great"
                feedlabelview.text = feedlabel
                return true
//            } else if ((45<=RSHK&&RSHK<=100)){
//                if(60>LSHK){
//                    feedlabel = "raise your left butt a bit more"
//                    feedlabelview.text = feedlabel
//                }else if(60<LSHK){
//                    feedlabel = "lower your left butt a bit more"
//                    feedlabelview.text = feedlabel
//
//                }
//            }else if (45<=LSHK&&LSHK<=100){
//                if(40>RSHK){
//                    feedlabel = "raise your right butt a bit more"
//                    feedlabelview.text = feedlabel
//                }else if(60<RSHK){
//                    feedlabel = "lower your right butt a bit more"
//                    feedlabelview.text = feedlabel
//
//                }
//
//            }
            }else{
                //print("no")
                return false
            }

        }else if (exer=="PUSHUP"){
            let RWES = angle(firstLandmark: rightwrist, midLandmark: rightwrist, lastLandmark: rightshoulder)
            let RSHK = angle(firstLandmark: rightshoulder, midLandmark: righthip, lastLandmark: rightknee )
            let RHKA = angle(firstLandmark: righthip, midLandmark: rightknee, lastLandmark: rightankle)
            let RESH = angle(firstLandmark: rightelbow, midLandmark: rightshoulder, lastLandmark: righthip)
            
            let LWES = angle(firstLandmark: leftwrist, midLandmark: leftwrist, lastLandmark: leftshoulder)
            let LSHK = angle(firstLandmark: leftshoulder, midLandmark: lefthip, lastLandmark: leftknee )
            let LHKA = angle(firstLandmark: lefthip, midLandmark: leftknee, lastLandmark: leftankle)
            let LESH = angle(firstLandmark: leftelbow, midLandmark: leftshoulder, lastLandmark: lefthip)
            
            if((RWES>=35 && RWES <= 95 && RSHK>=165 && RHKA >= 165 && RESH <= 20)||(LWES>=35 && LWES <= 95 && LSHK>=165 && LHKA >= 165 && LESH <= 20)){
                //print("RSHK ready ok")
                return true

            }else{
                //print("no")
                return false
            }
            
        }else if(exer == "LUNGE"){

            let RSHK = angle(firstLandmark: rightshoulder, midLandmark: righthip, lastLandmark: rightknee )
            let RHKA = angle(firstLandmark: righthip, midLandmark: rightknee, lastLandmark: rightankle)
 
            let LHKA = angle(firstLandmark: lefthip, midLandmark: leftknee, lastLandmark: leftankle)
            let RKH_LK = angle(firstLandmark: rightknee, midLandmark: rightknee, lastLandmark: leftknee)
            
            let LSHK = angle(firstLandmark: leftshoulder, midLandmark: lefthip, lastLandmark: leftknee )
            
            let LKH_RK = angle(firstLandmark: leftknee, midLandmark: leftknee, lastLandmark: rightknee)
            
            if((RHKA <= 110 && LSHK >= 150 && LHKA <= 110)){
                print("LUNGE right exer ok")
                progresslabel = "motioningLeft"
                return true
            }else if ((LHKA <= 110 && RSHK >= 150 && RHKA <= 110)){
                print("LUNGE left exer ok")
                progresslabel = "motioningRight"
                return true
            }else{
                print("no")
                return false
            }
            
        }else if(exer == "SIDE"){
            let LSHK = angle(firstLandmark: leftshoulder, midLandmark: lefthip, lastLandmark: leftknee)
            let RSHK = angle(firstLandmark: rightshoulder, midLandmark: righthip, lastLandmark: rightknee)
            
            if((progresslabel == "ready" || progresslabel == "normal") && LSHK <= 70 ){
                progresslabel = "motioningLeft"
                return true
            }else if(progresslabel == "ready_Left" && RSHK <= 70){
                progresslabel = "motioningRight"
                return true
            }
            // FEEDBACK
        }else if(exer == "SITUP"){
            
        }
        
        
        return false
        
    }
    
    
    
    func angle(
          firstLandmark: Joint,
          midLandmark: Joint,
          lastLandmark: Joint
      ) -> CGFloat {
          let radians: CGFloat =
              atan2(lastLandmark.position.y - midLandmark.position.y,
                        lastLandmark.position.x - midLandmark.position.x) -
                atan2(firstLandmark.position.y - midLandmark.position.y,
                        firstLandmark.position.x - midLandmark.position.x)
          var degrees = radians * 180.0 / .pi
          degrees = abs(degrees) // Angle should never be negative
          if degrees > 180.0 {
              degrees = 360.0 - degrees // Always get the acute representation of the angle
          }
          
//          print("fl: \(firstLandmark.position), ml: \(midLandmark.position), ll:\(lastLandmark.position)")
          return degrees
      }

    /// Vertically flips and draws the given image.
    ///
    /// - parameters:
    ///     - image: The image to draw onto the context (vertically flipped).
    ///     - cgContext: The rendering context.
    func draw(image: CGImage, in cgContext: CGContext) {
        cgContext.saveGState()
        // The given image is assumed to be upside down; therefore, the context
        // is flipped before rendering the image.
        cgContext.scaleBy(x: 1.0, y: -1.0)
        // Render the image, adjusting for the scale transformation performed above.
        let drawingRect = CGRect(x: 0, y: -image.height, width: image.width, height: image.height)
        cgContext.draw(image, in: drawingRect)
        cgContext.restoreGState()
    }

    /// Draws a line between two joints.
    ///
    /// - parameters:
    ///     - parentJoint: A valid joint whose position is used as the start position of the line.
    ///     - childJoint: A valid joint whose position is used as the end of the line.
    ///     - cgContext: The rendering context.
    func drawLine(from parentJoint: Joint,
                  to childJoint: Joint,
                  in cgContext: CGContext) {
        cgContext.setStrokeColor(segmentColor.cgColor)
        cgContext.setLineWidth(segmentLineWidth)

        cgContext.move(to: parentJoint.position)
        cgContext.addLine(to: childJoint.position)
        cgContext.strokePath()
    }

    /// Draw a circle in the location of the given joint.
    ///
    /// - parameters:
    ///     - circle: A valid joint whose position is used as the circle's center.
    ///     - cgContext: The rendering context.
    private func draw(circle joint: Joint, in cgContext: CGContext) {
        cgContext.setFillColor(jointColor.cgColor)

        let rectangle = CGRect(x: joint.position.x - jointRadius, y: joint.position.y - jointRadius,
                               width: jointRadius * 2, height: jointRadius * 2)
        cgContext.addEllipse(in: rectangle)
        cgContext.drawPath(using: .fill)
    }
}
