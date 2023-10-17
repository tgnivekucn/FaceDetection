//
//  ViewController.swift
//  FaceDetection
//
//  Created by SomnicsAndrew on 2023/10/13.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mImageView.clipsToBounds = false
        mImageView.image = UIImage(named: "person11")

        FaceDetection.shared.detect2(imageView: self.mImageView) { [weak self] faceBounds, leftEyePoint, rightEyePoint in
            guard let self = self else { return }
            DrawFaceDetectResultHelper.shared.drawResult(image: self.mImageView.image!,
                                                         imageView: self.mImageView,
                                                         faceBounds: faceBounds,
                                                         faceLeftEyePoint: leftEyePoint,
                                                         faceRightEyePoint: rightEyePoint)
        }

    }


}

