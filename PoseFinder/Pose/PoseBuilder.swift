/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The implementation of a structure that analyzes the PoseNet model outputs to detect
 single or multiple poses.
*/

import CoreGraphics
import UIKit

struct PoseBuilder {
    /// A prediction from the PoseNet model.
    ///
    /// Prediction outputs are analyzed to find and construct poses.
    let output: PoseNetOutput
    let label4: UILabel!

    /// A transformation matrix used to map joints from the PoseNet model's input image size onto the original image size.
    let modelToInputTransformation: CGAffineTransform

    /// The parameters the Pose Builder uses in its pose algorithms.
    var configuration: PoseBuilderConfiguration

    init(output: PoseNetOutput, configuration: PoseBuilderConfiguration, inputImage: CGImage, label4: UILabel) {
        self.output = output
        self.configuration = configuration
        self.label4 = label4

        // Create a transformation matrix to transform joint positions back into the space
        // of the original input size.
        modelToInputTransformation = CGAffineTransform(scaleX: inputImage.size.width / output.modelInputSize.width,
                                                       y: inputImage.size.height / output.modelInputSize.height)
    }
}
