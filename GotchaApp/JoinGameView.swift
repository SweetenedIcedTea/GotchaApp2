//
//  JoinGameView.swift
//  GotchaApp
//
//  Created by Ethan Zhang on 5/30/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class JoinGamesViewController: UIViewController {
    var me = Me!
    var game = Game(admin: errorPlayer, name: "error")
    var ref : DatabaseReference!
    
    @IBOutlet var numPlayerLabel: UILabel!
    @IBOutlet var gameNameLabel: UILabel!
    
    
    @IBAction func joinGame(_ sender: UIButton) {
        print("Join Pressed")
        ref = Database.database().reference(withPath: "games").child(game.name).child("players")
        ref.updateChildValues([
            me.name: me.toAnyObject()
            ])
        self.performSegue(withIdentifier: "JoinedGame", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        numPlayerLabel.text = "\(game.players.count)"
        gameNameLabel.text = game.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("AddGamesViewController Appearing")
    }
    
}

