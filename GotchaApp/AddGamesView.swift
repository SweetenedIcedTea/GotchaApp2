//
//  AddGamesView.swift
//  GotchaApp
//
//  Created by Ethan Zhang on 5/16/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AddGamesViewController: UIViewController {
    var me = Me!
    let ref = Database.database().reference(withPath: "games")
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBAction func tapRecognized(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
    }
    
    @IBAction func addGame(_ sender: UIButton) {
        print("Register Pressed")
        let nameText = nameTextField.text
        print("Name: \(nameText!)")
        
        let newGame = Game(admin: me, name: nameText!)
        let newGameRef = self.ref.child(nameText!.lowercased())
        newGameRef.setValue(newGame.toAnyObject())
        self.performSegue(withIdentifier: "unwindToGamesSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("AddGamesViewController Appearing")
    }
    
}

