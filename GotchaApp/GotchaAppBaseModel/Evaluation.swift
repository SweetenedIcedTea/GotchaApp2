//
//  Evaluation.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 5/8/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation
import UIKit

class Evaluation: CustomStringConvertible{
    var imageString: String
    var target: Player
    var numVotes: Int
    var rating: Double
    
    init(imageString: String, target: Player){
        self.imageString = imageString
        self.target = target
        numVotes = 0
        rating = 0
    }
    
    func voteYes(){
        rating += 1
        numVotes += 1
    }
    
    func voteNo(){
        rating -= 1
        numVotes += 1
    }
    
    var description: String {
        return "Evaluation for target: \(target.username)"
    }
    
    func toAnyObject()-> Any{
        return([
            "imageString": imageString,
            "target": "myTarget",
            "numVotes": numVotes,
            "rating" : rating
            ])
    }
    
}
