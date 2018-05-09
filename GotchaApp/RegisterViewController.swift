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
    let ref = Database.database().reference(withPath: "registered-players")
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    
    @IBAction func registerPressed(_ sending: UIButton){
        print("Register Pressed")
                let nameText = nameTextField.text
        let userText = userTextField.text
        let passText = passTextField.text
        print("Name: \(nameText!) | Username: \(userText!) | Password: \(passText!)")
        
        let newPlayer = Player(name: nameText!, username: userText!, pass: passText!)
        let newPlayerRef = self.ref.child(userText!.lowercased())
        newPlayerRef.setValue(newPlayer.toAnyObject())
        
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
