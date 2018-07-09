//
//  ViewController.swift
//  seeFood
//
//  Created by OLAJUWON on 7/9/18.
//  Copyright © 2018 OLAJUWON. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
   
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
       imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciImage =  CIImage(image: userPickedImage) else {
                fatalError("Couldnt convert the uiImage into a CIImage")
            }
            
            detest(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detest(image: CIImage){
        guard let model =  try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading coreML model failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Error classifying resultd")
            }
            if let firstResult = result.first {
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "HotDog!"
                }else{
                    self.navigationItem.title = "Not HotDog!"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
        try handler.perform([request])
        } catch{
            print("error")
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    


}

