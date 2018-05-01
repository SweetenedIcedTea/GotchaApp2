//
//  Image.swift
//  GotchaBaseModel
//
//  Created by Ethan Zhang on 4/21/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation

struct Image: Hashable{
    let data: String
    var rating: Int
    var votes: Int
    var target: Player
    
    init(data: String, target: Player){
        self.data = data
        rating = 0
        votes = 0
        self.target = target
    }
    
    var hashValue: Int {
        return(data.hashValue &* 88993)
    }
    
    var avgRating: Double{
        if votes == 0{
            print("No votes cast yet")
            return(0.0)
        }
        return(Double(rating) / Double(votes))
    }
    
    static func == (lhs: Image, rhs: Image) -> Bool {
        return lhs.data == rhs.data
    }
}

