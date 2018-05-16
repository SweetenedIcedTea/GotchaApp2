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

class SendViewController: UIViewController{
    let ref = Database.database().reference(withPath: "all-evaluations")
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var visibilityBackground: UIView!
    var image: UIImage!
    
    @IBAction func yesButtonTapped(){
        print("Yes button was tapped")
        
        //Encoding image to string
        let loadedImageData = UIImagePNGRepresentation(imageView.image!)!
        let strBase64 = loadedImageData.base64EncodedString(options: .lineLength64Characters)
        
        let newEvaluation = Evaluation(imageString: strBase64, targetUserName: "TargetUserName")
        
        let newEvalRef = self.ref.child("EvalForTargetTest")
        newEvalRef.setValue(newEvaluation.toAnyObject())
        
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
