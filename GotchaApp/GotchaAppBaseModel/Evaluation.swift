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
    var targetUserName: String
    var numVotes: Int
    var rating: Double
    
    init(imageString: String, targetUserName: String){
        self.imageString = imageString
        self.targetUserName = targetUserName
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
        return "Evaluation for target: \(targetUserName)"
    }
    
    func toAnyObject()-> Any{
        return([
            "imageString": imageString,
            "targetUserName": targetUserName,
            "numVotes": numVotes,
            "rating" : rating
            ])
    }
    
}
