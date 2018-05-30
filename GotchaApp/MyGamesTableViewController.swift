//
//  MyGamesTableViewController.swift
//  GotchaApp
//
//  Created by Ethan Zhang on 5/29/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MyGamesTableViewController: UITableViewController {
    var me: Player = Me!
    var ref : DatabaseReference!
    var games = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "games")
        ref.observe(.value, with: { snapshot in
            var newGames: [Game] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let gameItem = Game(snapshot: snapshot) {
                    if gameItem.players.contains(self.me) && gameItem.admin != self.me{
                        newGames.append(gameItem)
                        print("Added \(gameItem.name)")
                    }
                    if gameItem.admin == self.me{
                        newGames.append(gameItem)
                        print("Added \(gameItem.name)")
                    }
                }
            }
            
            self.games = newGames
            self.tableView.reloadData()
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("GamesViewController Appearing")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
        return(games.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as!
        GameCell
        
        // Set the text on the cell with the description of the item that is at the nth index of items, where n = row this cell
        let game = games[indexPath.row]
        
        cell.nameLabel.text = game.name
        cell.adminLabel.text = game.admin.username
        
        return(cell)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let gameItem = games[indexPath.row]
        ref = Database.database().reference(withPath: "games").child(gameItem.name)
        if gameItem.admin == self.me{
            ref.updateChildValues([
                "isStarted": true
                ])
            print("\(gameItem.name) has been started")
        } else {
        print("\(self.me.name) is not an admin of this game")
        }
    }
    
    @IBAction func unwindToGames(unwindSegue: UIStoryboardSegue){
        print("unwind to Games triggered")
    }
    
}

