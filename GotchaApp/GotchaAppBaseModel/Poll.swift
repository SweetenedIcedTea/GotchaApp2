//
//  Poll.swift
//  GotchaBaseModel
//
//  Created by Ethan Zhang on 4/20/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import Foundation

class Poll{
    var images = [Image]()
    
    func addImage(image: Image){
        images.append(image)
    }

    func voteImage(image: Image, number: Int){
        if (number < 0 || number > 1){
            print("Rating not approprate")
            return
        }
        
        if let imageIndex = images.index(of: image){
            var currentImage = images[imageIndex]
            let newRating = currentImage.rating + number
            currentImage.rating = newRating
            let newAmount = currentImage.votes + 1
            currentImage.votes = newAmount
            images[imageIndex] = currentImage
        } else{
            print("getting image error")
            return
        }
    }
    
    func imageStatus(image: Image){
        if let imageIndex = images.index(of: image){
            let currentImage = images[imageIndex]
            print("Rating: \(currentImage.rating)")
            print("Votes: \(currentImage.votes)")
            print("Average Rating: \(currentImage.avgRating)")
        } else{
            print("getting image error")
            return
        }
    }
    
    func getImage(image: Image)-> Image{
        if let imageIndex = images.index(of: image){
           return(images[imageIndex])
        } else{
            print("getting image error")
            return(Image(data: "Error", target: errorPlayer))
        }
    }
}
