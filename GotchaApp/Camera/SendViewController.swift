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
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var visibilityBackground: UIView!
    var image: UIImage!
    var me: Player = Me!
    
    @IBAction func yesButtonTapped(){
        print("Yes button was tapped")
        
//        sendImage()
        presentTargetSelectingAlert()
        
    }
    
    func sendImage(forName: String){
        //Encoding image
        let loadedImageData = UIImagePNGRepresentation(imageView.image!)!
        let imageRef = storageRef.child("images/evalFor\(forName).png")
//        let imageRef = storageRef.child("images/eval.png")
        let upLoadTask = imageRef.putData(loadedImageData)
        
        upLoadTask.observe(.success) { snapshot in
            print("success uploading!")
        }
        upLoadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print("object was not found")
                    break
                case .unauthorized:
                    print("user doesn't have authorization")
                    break
                case .cancelled:
                    print("user cancelled the upload")
                    break
                case .unknown:
                    print("unknown reason for failure")
                    break
                default:
                    print("idk why")
                    break
                }
            }
        }
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
                    
                    self.sendImage(forName: title)
                    self.performSegue(withIdentifier: "backToCamSegue", sender: nil)
                    
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
        let gamesref = Database.database().reference(withPath: "games")
        gamesref.observe(.value, with: { snapshot in
            var newGames: [Game] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let gameItem = Game(snapshot: snapshot) {
                    
                    if gameItem.players.contains(self.me){
                        newGames.append(gameItem)
                    }
                    
                }
            }
            
            self.games = newGames
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
