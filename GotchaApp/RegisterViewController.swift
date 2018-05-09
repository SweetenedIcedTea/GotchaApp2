//
//  RegisterViewController.swift
//  GotchaApp
//
//  Created by Ethan Zhang on 5/2/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterViewController: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    
    @IBAction func registerPressed(_ sending: UIButton){
        print("Register Pressed")
        ref = Database.database().reference()
        let nameText = nameTextField.text
        let userText = userTextField.text
        let passText = passTextField.text
        print("Name: \(nameText!) | Username: \(userText!) | Password: \(passText!)")
        self.ref.child("users").child(user.uid).setValue(["username": username])
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
