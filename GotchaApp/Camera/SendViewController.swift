//
//  SendViewController.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 4/28/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
//import Firebase/Storage

class SendViewController: UIViewController{
    let ref = Database.database().reference(withPath: "all-evaluations")
//    let imagesRef = Storage.storage().reference().child("images/eval.png")
    let storageRef = Storage.storage().reference()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var visibilityBackground: UIView!
    var image: UIImage!
    var me: Player = Me!
    
    @IBAction func yesButtonTapped(){
        print("Yes button was tapped")
        
        //Encoding image
        let loadedImageData = UIImagePNGRepresentation(imageView.image!)!
        
        //let imageRef = storageRef.child("images/evalFor\(title).png")
        let imageRef = storageRef.child("images/eval.png")
        let upLoadTask = imageRef.putData(loadedImageData)
        
        upLoadTask.observe(.success) { snapshot in
            print("success uploading!")
        }
        upLoadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print("object was not found")
                    break
                case .unauthorized:
                    print("user doesn't have authorization")
                    break
                case .cancelled:
                    print("user cancelled the upload")
                    break
                case .unknown:
                    print("unknown reason for failure")
                    break
                default:
                    print("idk why")
                    break
                }
            }
        }
        
    }
    
    func presentTargetSelectingAlert(str64: String){
        let alert = UIAlertController(title: "Please choose your target", message: nil, preferredStyle: .alert)
        
        for target in me.targets{
            let title = target.username
            let action = UIAlertAction(title: title, style: .default) { (_) in
                let newEvaluation = Evaluation(targetUserName: title)
                
                let newEvalRef = self.ref.child("EvalFor\(title)")
                newEvalRef.setValue(newEvaluation.toAnyObject())
                //instead of the above three lines, do the code in yesButtonTapped to upload the image file with the correct path name
            }
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func noButtonTapped(){
        print("No button was tapped")
    }
    
    
    override func viewDidLoad() {
        // Set the image
        self.imageView.image = self.image
        
        // Visibility background
        let gradient = CAGradientLayer()
        gradient.frame = visibilityBackground.bounds
        
        let dark = UIColor(white: 0.0, alpha: 0.3).cgColor
        let light = UIColor(white: 0.0, alpha: 0.1).cgColor
        let clear = UIColor(white: 0.5, alpha: 0.0).cgColor
        
        gradient.colors = [dark, clear, clear, light, dark]
        
        visibilityBackground.layer.insertSublayer(gradient, at: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
