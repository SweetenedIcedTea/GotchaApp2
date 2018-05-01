//
//  Game.swift
//  GotchaBaseModel
//
//  Created by Ethan Zhang on 4/4/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation

class Game: Hashable, CustomStringConvertible{
    var players = [Player]()
    var admin: Player
    var name: String
    var code: String
    var isWinner: Bool = false
    
    var hashValue: Int {
        return(admin.hashValue &* code.hashValue &* name.hashValue &* 88993)
    }
    
    var description: String{
        return("admin: \(admin), name: \(name)")
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.admin == rhs.admin && lhs.code == rhs.code && lhs.name == rhs.name
    }
    
    init(admin: Player, name: String){
        self.admin = admin
        players.append(admin)
        self.name = name
        code = "xd"
        code = generateCode()
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
}
