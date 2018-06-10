//
//  SendingEvalViewController.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 6/5/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class SendingEvalViewController: UIViewController {
    let storageRef = Storage.storage().reference()
    var me: Player = Me!
    
    var image: UIImage!
    var forName: String!
    @IBOutlet var sendingLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set the image
        self.imageView.image = self.image
        self.sendImage(forName: self.forName)
        self.sendingLabel.text = "Sending Evaluation for \(forName!)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendImage(forName: String){
        //Encoding image
        let loadedImageData = UIImagePNGRepresentation(imageView.image!)!
        let imageRef = storageRef.child("images/evalFor\(forName).png")
        //        let imageRef = storageRef.child("images/eval.png")
        let upLoadTask = imageRef.putData(loadedImageData)
        
        upLoadTask.observe(.progress) { snapshot in
            self.progressView.observedProgress = snapshot.progress
        }
        
        upLoadTask.observe(.success) { snapshot in
            print("success uploading!")
            let successAlert = UIAlertController(title: "Success uploading image!", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default){ (_) in
                self.performSegue(withIdentifier: "fromSendingToCam", sender: nil)
            }
            
            successAlert.addAction(cancelAction)
            
            self.present(successAlert, animated: true, completion: nil)
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        print("SendingEvalVC Appearing")
    }
}
