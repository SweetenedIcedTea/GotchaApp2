//
//  Game.swift
//  GotchaBaseModel
//
//  Created by Ethan Zhang on 4/4/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation
import Firebase

class Game: Hashable, CustomStringConvertible{
    var players: [Player]
    var admin: Player
    var name: String
    var isWinner: Bool = false
    
    var hashValue: Int {
        return(admin.hashValue &* name.hashValue &* 88993)
    }
    
    var description: String{
        return("admin: \(admin), name: \(name), players: \(players)")
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.admin == rhs.admin && lhs.name == rhs.name
    }
    
    init(admin: Player, name: String){
        self.admin = admin
        players = [Player]()
        players.append(admin)
        self.name = name
    }
    
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let admin = value["admin"] as? [String: Any],
            let players = value["players"] as? [String: [String: Any]] else {
                return nil
        }
        self.name = name
        self.admin = errorPlayer
        self.players = [errorPlayer]
        self.admin = self.toPlayer(values: admin)
        self.players = self.toPlayers(values: players)
    }
 
    
    func generateCode()-> String{
        //randomly generate a code
        return "random string"
    }
    
    func addPlayer(player: Player){
        players.append(player)
    }
    
    func listPlayers(){
        for player in players{
            print(player)
        }
    }
    
    func eliminatePlayer(player: Player){
        if let playerIndex = players.index(of: player){
            players.remove(at: playerIndex)
        } else{
            print("eliminate error")
            return
        }
        if players.count == 1{
            isWinner = true
        }
    }
    
    func startGame(){
        print("Game starting!")
    }
    
    func playersToAnyObject(_ players: [Player])-> [String: [String: Any]]{
        var result = [String: [String: Any]]()
        for player in players{
            let addOn = player.toAnyObject() as! [String: Any]
            result[player.name] = addOn
        }
        return(result)
    }
    
    func toAnyObject()-> Any{
        return([
            "name": name,
            "admin" : admin.toAnyObject(),
            "players" : playersToAnyObject(players)
            ])
    }
    
    func toPlayer(values: [String: Any])-> Player{
        let name = values["name"] as! String
        let username = values["username"] as! String
        let points = values["points"] as! Int
        return(Player(name: name, username: username, points: points))
    }
    
    func toPlayers(values: [String: [String: Any]])-> [Player]{
        var result = [Player]()
        for(_, playerData) in values{
            let player = toPlayer(values: playerData)
            result.append(player)
        }
        return(result)
    }
}
