//
//  DrawFaceDetectResultHelper.swift
//  FaceDetection
//
//  Created by SomnicsAndrew on 2023/10/17.
//

import UIKit
import CoreImage

class DrawFaceDetectResultHelper {
    static var shared = DrawFaceDetectResultHelper()

    func drawResult(image: UIImage, imageView: UIImageView, faceBounds: CGRect, faceLeftEyePoint: CGPoint, faceRightEyePoint: CGPoint) {
        if let faceViewBounds = getBoundInImageView(image: image, bounds: faceBounds, imageView: imageView) {
            print("After convert, bounds are \(faceViewBounds)")
            
            let faceBox = UIView(frame: faceViewBounds)
            faceBox.layer.borderWidth = 3
            faceBox.layer.borderColor = UIColor.red.cgColor
            faceBox.backgroundColor = UIColor.clear
            imageView.addSubview(faceBox)
            
            print("Left eye bounds are \(faceLeftEyePoint)")
            if let leftEyePoint = getCGPointInImageView(image: image,
                                                        point: faceLeftEyePoint,
                                                        imageView: imageView) {
                let leftEyeBox = UIView(frame: CGRect(origin: leftEyePoint, size: CGSize(width: 3, height: 3)))
                leftEyeBox.backgroundColor = .red
                imageView.addSubview(leftEyeBox)
            }
            
            print("Right eye bounds are \(faceRightEyePoint)")
            if let rightEyePoint = getCGPointInImageView(image: image,
                                                         point: faceRightEyePoint,
                                                         imageView: imageView) {
                let rightEyeBox = UIView(frame: CGRect(origin: rightEyePoint, size: CGSize(width: 3, height: 3)))
                rightEyeBox.backgroundColor = .red
                imageView.addSubview(rightEyeBox)
            }
        }
    }
    
    // MARK: - Private methods
    private func getBoundInImageView(image: UIImage, bounds: CGRect, imageView: UIImageView) -> CGRect? {
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
    
    private func getCGPointInImageView(image: UIImage, point: CGPoint, imageView: UIImageView) -> CGPoint? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        let imageWidthScale = imageView.bounds.width / ciImage.extent.size.width
        let imageHeightScale = imageView.bounds.height / ciImage.extent.size.height
        let x = (point.x * imageWidthScale)
        let y = ((ciImage.extent.size.height - point.y) * imageHeightScale)
        return CGPoint(x: x, y: y)
    }
}
