//
//  EvaluationsViewController.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 4/25/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import UIKit
import Firebase

class EvaluationsViewController: UIViewController {
    var me: Player = Me!
    let ref = Database.database().reference(withPath: "all-evaluations")
    var evaluations = [Evaluation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Decoding string to image
//        let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
//        let decodedImage = UIImage(data: dataDecoded)
//        let reorientedImage = UIImage(cgImage: (decodedImage?.cgImage)!, scale: 1.0, orientation: .right)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("EvaluationsVC disappearing")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("EvaluationsViewController Appearing")
        
        //Get evaluations from database
        //filter out evaluations that you already answered for
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            for eval in value!{
                let evalProperty = eval.value as? [String: Any]
                
                var numVotes = 0
                var imageString = ""
                var rating = 0
                var targetUserName = ""
                
                for property in evalProperty!{
                    print(property.key)
                    switch property.key{
                    case "numVotes":
                        numVotes = property.value as! Int
                    case "target":
                        targetUserName = property.value as! String
                    case "imageString":
                        imageString = property.value as! String
                    case "rating":
                        rating = property.value as! Int
                    default:
                        print("error: unrecognized evaluation property key- \(property.key)")
                    }
                }
                
                let newEval = Evaluation(imageString: imageString, targetUserName: targetUserName)
                
            }
        })
    }
    
}
