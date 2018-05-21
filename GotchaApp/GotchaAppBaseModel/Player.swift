//
//  Player.swift
//  GotchaBaseModel
//
//  Created by Ethan Zhang on 4/4/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation

class Player: Hashable, CustomStringConvertible{
    var name: String
    var username: String
    var password: Int
    var points: Int
    var targets = [Player]()
    
    var hashValue: Int {
        return username.hashValue &* name.hashValue &* 88993
    }
    
    var description: String{
        return "\(name), username: \(username)"
    }
    
    init(name: String, username: String, pass: String, points: Int){
        self.name = name
        self.username = username
        self.password = Player.hashPass(pass)
        self.points = points
    }
    
    init(name: String, username: String, points: Int){
        self.name = name
        self.username = username
        password = 0
        self.points = points
    }
    
    func addPoints(_ add: Int){
        points += add
    }
    
    func subPoints(_ sub: Int){
        points -= sub
    }
    
    private static func hashPass(_ password: String)-> Int{
        return(password.hashValue &* 93491)
    }
    
    func decryptPass(pass: Int)-> Int{
        return(0)
    }
    
    func giveTarget(game: Game){
        
    }
    
    func toAnyObject()-> Any{
        return([
            "name": name,
            "username": username,
            "password": password,
            "points" : points
            ])
    }

}

extension Player: Equatable{
    static func == (p1: Player, p2: Player) -> Bool {
        return p1.name == p2.name && p1.username == p2.username && p1.password == p2.password
    }
}
