//
//  RegisterViewController.swift
//  GotchaApp
//
//  Created by Ethan Zhang on 5/2/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class RegisterViewController: UIViewController,  UITextFieldDelegate{
    let ref = Database.database().reference(withPath: "registered-players")
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        userTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
    
    @IBAction func registerPressed(_ sending: UIButton){
        print("Register Pressed")
        let nameText = nameTextField.text
        let userText = userTextField.text
        let passText = passTextField.text
        let points = 0
        print("Name: \(nameText!) | Username: \(userText!) | Password: \(passText!)")
        
        let newPlayer = Player(name: nameText!, username: userText!, pass: passText!, points: points)
        let newPlayerRef = self.ref.child(userText!.lowercased())
        newPlayerRef.setValue(newPlayer.toAnyObject())
        performSegue(withIdentifier: "segueToLogin", sender: nil)
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
