//
//  Evaluation.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 5/8/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation
import UIKit

class Evaluation: CustomStringConvertible, Equatable{
    var targetUserName: String
    var numVotes: Int
    var rating: Double
    var experation: Date
    
    init(targetUserName: String, exp: Date){
        self.targetUserName = targetUserName
        numVotes = 0
        rating = 0
        self.experation = exp
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
        return "Evaluation for target: \(targetUserName)"
    }
    
    func toInterval(_ time: Date)-> TimeInterval{
        return time.timeIntervalSince1970
    }
    
    func toAnyObject()-> Any{
        return([
            "targetUserName": targetUserName,
            "numVotes": numVotes,
            "rating" : rating,
            "experation": toInterval(experation)
            ])
    }
    
    static func == (eval1: Evaluation, eval2: Evaluation) -> Bool {
        return
            eval1.targetUserName == eval2.targetUserName &&
            eval1.numVotes == eval2.numVotes &&
            eval1.rating == eval2.rating
    }
    
}
