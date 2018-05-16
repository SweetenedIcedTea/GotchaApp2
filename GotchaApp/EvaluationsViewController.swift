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
    let ref = Database.database().reference(withPath: "all-evaluations")
    var evaluations: [Evaluation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            let username = value?["username"] as? String ?? ""
//            let user = User(username: username)
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            for eval in value?{
//                evaluations.append(Evaluation(imageString: eval.imageString, target: Player))
//            }
//        })
        
        //Decoding string to image
//        let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
//        let decodedImage = UIImage(data: dataDecoded)
//        let reorientedImage = UIImage(cgImage: (decodedImage?.cgImage)!, scale: 1.0, orientation: .right)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("EvaluationsViewController Appearing")
        
        //Get evaluations from database
        //filter out evaluations that you already answered for
    }
    
}
