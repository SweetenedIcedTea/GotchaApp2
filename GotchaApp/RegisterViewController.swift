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
    
    @IBOutlet var nameErrorLabel: UILabel!
    @IBOutlet var usernameErrorLabel: UILabel!
    @IBOutlet var passwordErrorLabel: UILabel!
    
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
        var allFieldsAreFilled = true
        let points = 0
        
        if nameTextField.text == " " || nameTextField.text == ""{
            allFieldsAreFilled = false
            nameErrorLabel.text = "Please enter your name"
        } else {
            nameErrorLabel.text = " "
        }
        if userTextField.text == " " || userTextField.text == ""{
            allFieldsAreFilled = false
            usernameErrorLabel.text = "Please enter a username"
        } else {
            usernameErrorLabel.text = " "
        }
        if passTextField.text == " " || passTextField.text == ""{
            allFieldsAreFilled = false
            passwordErrorLabel.text = "Please enter a password"
        } else {
            passwordErrorLabel.text = " "
        }
        
        if allFieldsAreFilled == false{
            return
        }
        
        print("Name: \(nameText!) | Username: \(userText!) | Password: \(passText!)")
        
        let newPlayer = Player(name: nameText!, username: userText!, pass: passText!, points: points)
        let newPlayerRef = self.ref.child(userText!.lowercased())
        newPlayerRef.setValue(newPlayer.toAnyObject())

        Me = newPlayer
        self.performSegue(withIdentifier: "registeredSegue", sender: nil)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        userTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameErrorLabel.text = " "
        usernameErrorLabel.text = " "
        passwordErrorLabel.text = " "
        
        nameTextField.delegate = self
        passTextField.delegate = self
        userTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
