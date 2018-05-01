//
//  TargetingView.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 4/28/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import UIKit

class Line {
    var begin: CGPoint
    var end: CGPoint
    
    init(begin: CGPoint, end: CGPoint){
        self.begin = begin; self.end = end
    }
}

class TargetingView: UIView{
    var lines: [Line] = []
    
    override init(frame: CGRect) {
        //Why is the frame off by 27 points??
        let myFrame = CGRect(x: frame.minX - 27, y: frame.minY - 1, width: 240, height: 240)
        super.init(frame: myFrame)
        
        let x = frame.maxX - frame.minX
        let y = frame.maxY - frame.minY
        
        let xFifth = x/5
        
        lines = [
            Line(begin: CGPoint(x: 5, y: 5), end: CGPoint(x: 5, y: y-5)),
            Line(begin: CGPoint(x: x-5, y: 5), end: CGPoint(x: x-5, y: y-5)),
            Line(begin: CGPoint(x: 5, y: 5), end: CGPoint(x: xFifth, y: 5)),
            Line(begin: CGPoint(x: x-5-xFifth, y: 5), end: CGPoint(x: x-5, y: 5)),
            Line(begin: CGPoint(x: 5, y: y-5), end: CGPoint(x: xFifth, y: y-5)),
            Line(begin: CGPoint(x: x-5-xFifth, y: y-5), end: CGPoint(x: x-5, y: y-5))
        ]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 3
        path.lineCapStyle = .round
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        print("drawing target")
        for line in lines{
            UIColor(red: 247.0/255.0, green: 134.0/255.0, blue: 29.0/255.0, alpha: 0.8).setStroke()
            stroke(line)
        }
    }
}

