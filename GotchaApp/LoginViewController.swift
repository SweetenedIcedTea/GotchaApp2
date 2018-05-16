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

class LoginViewController: UIViewController,  UITextFieldDelegate {
    var ref : DatabaseReference!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var usernameErrorLabel: UILabel!
    @IBOutlet var passwordErrorLabel: UILabel!
    @IBOutlet var invalidLoginLabel: UILabel!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "registered-players")
        // Do any additional setup after loading the view, typically from a nib.
        usernameErrorLabel.text = nil
        passwordErrorLabel.text = nil
        invalidLoginLabel.text = nil
        
        usernameField.text = nil
        passwordField.text = nil
    }
    
    @IBAction func login(_ sender: UIButton) {
        let userID = usernameField.text!
        let passText = passwordField.text!
        if userID.count < 1 || passText.count < 1{
            return
        } else {
            print(userID.count, passText.count)
        }
        let passHash = passText.hashValue &* 93491
        ref.child(userID.lowercased()).observeSingleEvent(of: .value, with: { (snapshot) in
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
                Me = Player(name: name, username: username, pass: passText, points: points)
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            
        }) { (error) in
            print(error.localizedDescription)
            return
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
