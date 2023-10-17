//
//  CameraViewController.swift
//  FaceDetection
//
//  Created by SomnicsAndrew on 2023/10/17.
//

import UIKit

class CameraViewController: UIViewController {
    private let imagePicker = UIImagePickerController()
    private var imageView: UIImageView?
    private var button: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        imageView = UIImageView()
        if let imageView = imageView {
            imageView.backgroundColor = .yellow
            imageView.frame = CGRect(x: 50, y: 300, width: 300, height: 300)
            self.view.addSubview(imageView)
        }

        button = UIButton(frame: CGRect(x: 50, y: 100, width: 100, height: 50))
        if let button = button {
            button.setTitle("Capture", for: .normal)
            button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
            button.setTitleColor(.black, for: .normal)
            self.view.addSubview(button)
            button.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        }
    }

    @objc func takePhoto() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func startDetect(image: UIImage, imageView: UIImageView?) {
        if let imageView = imageView {
            FaceDetection.shared.detect2(imageView: imageView) { [weak self] faceBounds, leftEyePoint, rightEyePoint in
                DrawFaceDetectResultHelper.shared.drawResult(image: image,
                                                             imageView: imageView,
                                                             faceBounds: faceBounds,
                                                             faceLeftEyePoint: leftEyePoint,
                                                             faceRightEyePoint: rightEyePoint)
            }
        }
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageView = imageView {
                imageView.contentMode = .scaleAspectFit
                let image = pickedImage.fixOrientation()
                imageView.image = image
                startDetect(image: image, imageView: imageView)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// Ref: https://github.com/MetalPetal/MetalPetal/issues/54
public extension UIImage {
    /// Extension to fix orientation of an UIImage without EXIF
    func fixOrientation() -> UIImage {
        guard let cgImage = cgImage else { return self }
        if imageOrientation == .up { return self }
        var transform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }

        if let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            ctx.concatenate(transform)
            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            if let finalImage = ctx.makeImage() {
                return (UIImage(cgImage: finalImage))
            }
        }
        return self
    }
}
