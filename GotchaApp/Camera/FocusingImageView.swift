//
//  FocusingImageView.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 4/28/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import UIKit

class focusingRect {
    var rect: CGRect
    let dimensions = CGFloat(50)
    
    init(center: CGPoint){
        var xCoor = center.x;       var yCoor = center.y
        xCoor -= (dimensions/CGFloat(2));    yCoor -= (dimensions/CGFloat(2))
        
        let size = CGSize(width: dimensions, height: dimensions)
        let origin = CGPoint(x: xCoor, y: yCoor)
        
        self.rect = CGRect(origin: origin, size: size)
    }
}

//for drawing focusing rectangles and getting the location to focus on
class FocusingImageView: UIView{
    var lastTouchLocation: CGPoint?
    var rects: [focusingRect] = []
    var drawJustHappened: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func clearRects(){
        self.rects = []
        drawJustHappened = false
        setNeedsDisplay()
    }
    
    //Mark: Drawing
    
    func stroke(_ rect: CGRect){
        let path = UIBezierPath(rect: rect)
        path.lineWidth = 2
        UIColor(red: 247.0/255.0, green: 134.0/255.0, blue: 29.0/255.0, alpha: 1.0).setStroke()
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        print("drawing focus square")
        for focusingRect in rects{
            stroke(focusingRect.rect)
        }
    }
    
    func doADrawing(){
        setNeedsDisplay()
        drawJustHappened = true
        let _ = Timer.scheduledTimer(withTimeInterval: 1.3, repeats: false) { _ in
            self.clearRects()}
    }
    
    //Mark: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch occured")
        let touch = touches.first!
        let location = touch.location(in: self)
        
        let screenSize = self.bounds.size
        lastTouchLocation = CGPoint(x: touch.location(in: self).y / screenSize.height, y: 1.0 - touch.location(in: self).x / screenSize.width)
        
        rects = [focusingRect(center: location)]
        
    }
    
}

