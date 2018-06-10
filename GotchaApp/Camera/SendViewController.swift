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

class SendViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
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
        
        //presentTargetSelectingAlert()
        showPickerInActionSheet()
    }
    
    func showPickerInActionSheet() {
        
        //check to see if there are targets available
        
        let title = "Please choose your target"
        let message = "\n\n\n\n\n\n\n\n\n\n";
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alert.isModalInPopover = true;
        
        let alertFrame = alert.view.frame
//        let newFrame = CGRect(x: alertFrame.x, y: alertFrame.y, width: alertFrame.width, height: alertFrame.height)
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerHeight = 200
        let pickerWidth = Int(alertFrame.width)*3/4
        let pickerX = 16
        let pickerY = 24
        print(alertFrame.minX, alertFrame.minY)
        let pickerFrame: CGRect = CGRect(x: pickerX, y: pickerY, width: pickerWidth, height: pickerHeight) // CGRectMake(left), top, width, height) - left and top are like margins
        let picker: UIPickerView = UIPickerView(frame: pickerFrame);
        
//        picker.center = alert.view.convert(alert.view.center, from: alert.view.superview)
        //set the pickers datasource and delegate
        picker.delegate = self;
        picker.dataSource = self;
        
        //Add the picker to the alert controller
        alert.view.addSubview(picker);
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        
        let action = UIAlertAction(title: "Select", style: .default) { (_) in
            print("selected")
            let row = picker.selectedRow(inComponent: 0); print(row)
            let game = self.games[row]; print(game)
            let players = game.players
            let myIndex = players.index(of: self.me)!
            var myTarget: Player? = nil
            if players.count == myIndex+1{
                myTarget = players[0]
            } else {
                myTarget = players[myIndex+1]
            }
            let title = myTarget!.username
            var date = Date()
            date.addTimeInterval(86400)
            let newEvaluation = Evaluation(targetUserName: title, exp: date)
            
            let newEvalRef = self.ref.child("EvalFor\(title)")
            newEvalRef.setValue(newEvaluation.toAnyObject())
            self.forName = title
            //self.sendImage(forName: title)
            self.performSegue(withIdentifier: "showProgress", sender: nil)
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil);
    }
    
    func cancelSelection(sender: UIButton){
        print("Cancel")
        self.dismiss(animated: true, completion: nil);
        // We dismiss the alert. Here you can add your additional code to execute when cancel is pressed
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return games.count
    }
    
    // Return the title of each row in your picker ... In my case that will be the profile name or the username string
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let game = games[row]
        let players = game.players
        let myIndex = players.index(of: me)!
        var myTarget: Player? = nil
        if players.count == myIndex+1{
            myTarget = players[0]
        } else {
            myTarget = players[myIndex+1]
        }
        let title = myTarget!.username
        //print(title)
        return title
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
        case "backToCamSegue":
            print("going back to camVC")
        default:
            preconditionFailure("Unexpected segue identifier: \(id)")
        }
    }
    
    @IBAction func unwindToSend(unwindSegue: UIStoryboardSegue){
        print("unwind to send triggered")
    }
    
}

