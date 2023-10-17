//
//  FaceDetection.swift
//  FaceDetection
//
//  Created by SomnicsAndrew on 2023/10/13.
//

import UIKit
import CoreImage

// Ref: https://www.appcoda.com.tw/face-detection-core-image/
class FaceDetection {
    static var shared = FaceDetection()

    func detect2(imageView: UIImageView, callback: ((CGRect, CGPoint, CGPoint) -> Void)? = nil) {
        guard let image = imageView.image else {
            return
        }
        guard let personciImage = CIImage(image: image) else {
            return
        }
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)

        for face in faces as! [CIFaceFeature] {
            print("Found bounds are \(face.bounds)")
            callback?(face.bounds, face.leftEyePosition, face.rightEyePosition)           
        }
    }
}
