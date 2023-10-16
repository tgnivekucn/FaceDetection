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

    func detect(imageView: UIImageView) {
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
            
            let faceBox = UIView(frame: face.bounds)
            faceBox.frame.origin = CGPoint.zero
            faceBox.layer.borderWidth = 3
            faceBox.layer.borderColor = UIColor.red.cgColor
            faceBox.backgroundColor = UIColor.clear
            imageView.addSubview(faceBox)
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
        }
    }
    
    func detect2(imageView: UIImageView) {
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
            if let faceViewBounds = getFaceViewBounds(image: image,
                                                      face: face,
                                                      imageView: imageView) {
                print("After convert, bounds are \(faceViewBounds)")

                let faceBox = UIView(frame: faceViewBounds)
                
                faceBox.layer.borderWidth = 3
                faceBox.layer.borderColor = UIColor.red.cgColor
                faceBox.backgroundColor = UIColor.clear
                imageView.addSubview(faceBox)
                
                if face.hasLeftEyePosition {
                    print("Left eye bounds are \(face.leftEyePosition)")
                }
                
                if face.hasRightEyePosition {
                    print("Right eye bounds are \(face.rightEyePosition)")
                }
            }
        }
    }
    func convertImagePointToImageViewPoint(_ point: CGPoint, in imageView: UIImageView) -> CGPoint {
        guard let imageSize = imageView.image?.size else { return .zero }

        // Image frame in the imageView's coordinate system
        let imageFrame = imageView.contentClippingRect

        let imageViewPoint = CGPoint(
            x: imageFrame.origin.x + (point.x * imageFrame.size.width / imageSize.width),
            y: imageFrame.origin.y + (point.y * imageFrame.size.height / imageSize.height)
        )

        return imageViewPoint
    }

    func getFaceViewBounds(image: UIImage, face: CIFaceFeature, imageView: UIImageView) -> CGRect? {
        return getBoundInImageView(image: image, bounds: face.bounds, imageView: imageView)
    }

    func getBoundInImageView(image: UIImage, bounds: CGRect, imageView: UIImageView) -> CGRect? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        let imageWidthScale = imageView.bounds.width / ciImage.extent.size.width
        let imageHeightScale = imageView.bounds.height / ciImage.extent.size.height

        let x = (bounds.origin.x * imageWidthScale)
        let y = ((ciImage.extent.size.height - bounds.origin.y - bounds.height) * imageHeightScale)

        let width = bounds.width * imageWidthScale
        let height = bounds.height * imageHeightScale

        let faceRectangle = CGRect(x: x, y: y, width: width, height: height)
        return faceRectangle
    }
}


extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        let scale: CGFloat
        switch contentMode {
        case .scaleAspectFit:
            scale = min(bounds.width / image.size.width, bounds.height / image.size.height)
        case .scaleAspectFill:
            scale = max(bounds.width / image.size.width, bounds.height / image.size.height)
        default:
            return bounds
        }
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

