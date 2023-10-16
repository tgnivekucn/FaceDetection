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
        FaceDetection.shared.detect2(imageView: mImageView)
    }


}

