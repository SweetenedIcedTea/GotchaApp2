//
//  File.swift
//  GotchaApp
//
//  Created by Ethan Zhang on 5/2/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class LoginViewController: UIViewController {
    var ref : DatabaseReference!
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    
    
    @IBAction func loginPressed(_ sending: UIButton){
        let userID = userTextField.text
        let passText = passTextField.text!
        let passHash = passText.hashValue &* 93491
        ref.child(userID!.lowercased()).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if passHash != value?["password"] as? Int ?? -420{
                print("password is incorrect")
                return
            } else {
                print("password is correct")
                let username = value?["username"] as? String ?? "error"
                let name = value?["name"] as? String ?? "error"
                let points = value?["points"] as? Int ?? -420
                print("\(username), \(name), \(points)")
                self.performSegue(withIdentifier: "login", sender: nil)
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
            return
        }
 
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "registered-players")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
