//
//  ViewController.swift
//  final
//
//  Created by Jasper Lin on 2019/6/18.
//  Copyright © 2019 jasperlin1996. All rights reserved.
//

import UIKit
import CoreML
import Photos
import Foundation

class ViewController: UIViewController,  UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var detectImageView: UIImageView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
//    var model: Resnet50!
    var model: Inceptionv3!
    override func viewWillAppear(_ animated: Bool) {
//        model = Resnet50()
        model = Inceptionv3()
    }
    
    @IBAction func selectImageFromLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true)
    }
    @IBAction func camera(_ sender: Any) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            return
        }
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = true
        
        present(cameraPicker, animated: true)
    }
}
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        resultLabel.text = "Analyzing Image..."
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        detectImageView.image = newImage
        guard let prediction = try? model.prediction(image: pixelBuffer!)else {
            return
        }
        
        resultLabel.text = "\(prediction.classLabel.components(separatedBy: ",")[0].description)"
        // Store the classified image and its label
        let imageName = UUID().uuidString
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentDirectory.appendingPathComponent(imageName).appendingPathExtension("png")
        try? detectImageView.image?.pngData()?.write(to: url)
        
        // Store the image info in UserDefault
        let classifiedData = ClassifiedData(label: resultLabel.text ?? "Unknown class", imageName: imageName)
        let userDefault = UserDefaults.standard
        var tmp = [[String: Any]]()
        if let classifiedDataDicts = userDefault.array(forKey: "data") as? [[String: Any]] {
            tmp = classifiedDataDicts
        }
        tmp.append(["label": classifiedData.label, "imageName": classifiedData.imageName])
        userDefault.set(tmp, forKey: "data")
        TableViewController.readDataFromUserDefault()
        
        dismiss(animated: true, completion: nil)
    }
}

