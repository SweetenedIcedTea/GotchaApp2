//
//  File.swift
//  GotchaApp
//
//  Created by Ethan Zhang on 5/2/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation

import UIKit

class LoginViewController: UIViewController,  UITextFieldDelegate {
    
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
        // Do any additional setup after loading the view, typically from a nib.
        usernameErrorLabel.text = nil
        passwordErrorLabel.text = nil
        invalidLoginLabel.text = nil
        
        usernameField.text = nil
        passwordField.text = nil
    }
    
    @IBAction func login(_ sender: UIButton) {
        print("login pushed")
        
//        if usernameField.text == " " {
//            usernameErrorLabel.text = "Please enter a username"
//            return
//        } else {
//            let username = usernameField.text
//            usernameErrorLabel.text = " "
//        }
//        if passwordField.text == " " {
//            passwordErrorLabel.text = "Please enter a password"
//            return
//        } else {
//            let password = passwordField.text
//            passwordErrorLabel.text = " "
//        }
        
        //print(username, password)
        
        //Attempt to get player from database.
//        If (player does not exist) {
//            invalidLoginLabel.text = "Invalid username or password"
//        } else {
        performSegue(withIdentifier: "loginSegue", sender: self)
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
