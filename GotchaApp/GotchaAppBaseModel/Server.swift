//
//  Server.swift
//  GotchaBaseModel
//
//  Created by Ethan Zhang on 4/21/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation
/*
class Server{
    var games = [Game]()
    var poll = Poll()
    var players = Set<Player>()
    
    func addPlayer(name: String, username: String, pass: String){
        let newPlayer = Player(name: name, username: username, pass: pass)
        players.insert(newPlayer)
    }
    
    func addPlayerToGame(player: Player, game: Game){
        if doesGameExist(game: game){
            let gameIndex = games.index(of: game)
            let currentGame = games[gameIndex!]
            currentGame.addPlayer(player: player)
            games[gameIndex!] = currentGame
        } else {
            print("Game does not exist")
        }
    }
    
    func findPlayer(hash: Int)-> Player{
        for player in players{
            if hash == player.hashValue{
                return(player)
            }
        }
        print("could not find player")
        return(Player(name: "error", username: "error", pass: "error"))
    }
    
    func listPlayerHashes(){
        print("Player Hashes:")
        for player in players{
            print("\(player.username) = \(player.hashValue)")
        }
    }
    
    func listPlayers(){
        for player in players{
            print("\(player)")
        }
    }
    
    func findGame(hash: Int)-> Game{
        for game in games{
            if hash == game.hashValue{
                return(game)
            }
        }
        print("could not find game")
        return(errorGame)
    }
    
    func listGameHashes(){
        print("Game Hashes:")
        for game in games{
            print("\(game.name) = \(game.hashValue)")
        }
    }
    
    func listGames(){
        for game in games{
            print(game)
        }
    }
    
    func tag(player: Player, game: Game, data: Image){
        //incomplete
        poll.addImage(image: data)
    }
    
    //incomplete
    func vote(player: Player, image: Image, vote: Int){
        poll.voteImage(image: image, number: vote)
    }
    
    func newGame(admin: Player, name: String){
        let anime31953 = Game(admin: admin, name: name)
        games.append(anime31953)
    }

    
    func doesGameExist(game: Game)-> Bool{
        if games.contains(game){
           return(true)
        } else{
            return(false)
        }
    }
    
    func isPlayerInGame(player: Player, game: Game){
    }
}
*/
