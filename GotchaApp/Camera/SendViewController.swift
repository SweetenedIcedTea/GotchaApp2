//
//  SendViewController.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 4/28/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
//import Firebase/Storage

class SendViewController: UIViewController{
    let ref = Database.database().reference(withPath: "all-evaluations")
//    let imagesRef = Storage.storage().reference().child("images/eval.png")
    let storageRef = Storage.storage().reference()
    var games = [Game]()
    var forName: String = ""
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var visibilityBackground: UIView!
    var image: UIImage!
    var me: Player = Me!
    
    @IBAction func yesButtonTapped(){
        print("Yes button was tapped")
        
        presentTargetSelectingAlert()
        
    }
    
    
    func presentTargetSelectingAlert(){
        
        if games.count == 0{
            let noGamesAlert = UIAlertController(title: "Join a game before trying to eliminate players", message: nil, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.performSegue(withIdentifier: "backToCamSegue", sender: nil)
                
            }
            noGamesAlert.addAction(action)
            present(noGamesAlert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Please choose your target", message: nil, preferredStyle: .alert)
            
            for game in games{
                let players = game.players
                let myIndex = players.index(of: me)!
                var myTarget: Player? = nil
                if players.count == myIndex+1{
                    myTarget = players[0]
                } else {
                    myTarget = players[myIndex+1]
                }
                let title = myTarget!.username
                let action = UIAlertAction(title: title, style: .default) { (_) in
                    var date = Date()
                    date.addTimeInterval(86400)
                    let newEvaluation = Evaluation(targetUserName: title, exp: date)
                    
                    let newEvalRef = self.ref.child("EvalFor\(title)")
                    newEvalRef.setValue(newEvaluation.toAnyObject())
                    self.forName = title
//                    self.sendImage(forName: title)
                    self.performSegue(withIdentifier: "showProgress", sender: nil)
                    
                }
                alert.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func noButtonTapped(){
        print("No button was tapped")
    }
    
    
    override func viewDidLoad() {
        // Set the image
        self.imageView.image = self.image
        
        // Visibility background
        let gradient = CAGradientLayer()
        gradient.frame = visibilityBackground.bounds
        
        let dark = UIColor(white: 0.0, alpha: 0.3).cgColor
        let light = UIColor(white: 0.0, alpha: 0.1).cgColor
        let clear = UIColor(white: 0.5, alpha: 0.0).cgColor
        
        gradient.colors = [dark, clear, clear, light, dark]
        
        visibilityBackground.layer.insertSublayer(gradient, at: 0)
        
        getGames()
    }
    
    func getGames(){
        self.games = []
        let gamesref = Database.database().reference(withPath: "games")
        gamesref.observe(.value, with: { snapshot in
            var newGames: [Game] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let gameItem = Game(snapshot: snapshot) {
                    if gameItem.players.contains(self.me){
                        if gameItem.isStarted == true {
                            newGames.append(gameItem)
                        }
                    }
                }
            }
            
            self.games = newGames
            print(self.games)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier!
        switch id{
        case "showProgress":
            let SEVC = segue.destination as! SendingEvalViewController
            
            SEVC.image = self.image
            SEVC.forName = self.forName
            
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
}
