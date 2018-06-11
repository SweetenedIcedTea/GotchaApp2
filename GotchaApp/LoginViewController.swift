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
        usernameErrorLabel.text = " "
        passwordErrorLabel.text = " "
        invalidLoginLabel.text = " "
        
        usernameField.delegate = self
        passwordField.delegate = self
        
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        var allFieldsFilled = true
        if usernameField.text == " " || usernameField.text == ""{
            allFieldsFilled = false
            usernameErrorLabel.text = "Please enter your username"
        } else {
            usernameErrorLabel.text = " "
        }
        if passwordField.text == " " || passwordField.text == ""{
            allFieldsFilled = false
            passwordErrorLabel.text = "Please enter your username"
        } else {
            passwordErrorLabel.text = " "
        }
        if allFieldsFilled == false{
            return
        }
        
        let userID = usernameField.text!
        let passText = passwordField.text!
        
        let passHash = passText.hashValue &* 93491
        ref.child(userID.lowercased()).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if passHash != value?["password"] as? Int ?? -420{
                print("password is incorrect")
                self.invalidLoginLabel.text = "Password or Username incorrect"
                return
            } else {
                print("password is correct")
                let username = value?["username"] as? String ?? "error"
                let name = value?["name"] as? String ?? "error"
                let points = value?["points"] as? Int ?? -420
                print("\(username), \(name), \(points)")
                Me = Player(name: name, username: username, pass: passText, points: points)
                self.getMyTargets()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            
        }) { (error) in
            print(error.localizedDescription)
            return
        }
        
    }
    
    
    func getMyTargets(){
        let gamesref = Database.database().reference(withPath: "games")
        var myGames = [Game]()
        gamesref.observe(.value, with: { snapshot in
            var newGames: [Game] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let gameItem = Game(snapshot: snapshot) {
                    if gameItem.players.contains(Me!) && gameItem.admin != Me!{
                        newGames.append(gameItem)
                        print("Added \(gameItem.name)")
                    }
                    if gameItem.admin == Me!{
                        newGames.append(gameItem)
                        print("Added \(gameItem.name)")
                    }
                }
            }
            
            myGames = newGames
        })
        print(myGames)
        
        var myTargets = [Player]()
        
        for game in myGames{
            let players = game.players
            let myIndex = players.index(of: Me!)!
            var myTarget: Player? = nil
            if players.count == myIndex+1{
                myTarget = players[0]
            } else {
                myTarget = players[myIndex+1]
            }
            myTargets.append(myTarget!)
        }
        
        Me!.targets = myTargets
        
        print(myTargets)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue){
        print("unwind to Login triggered")
    }
    
}
