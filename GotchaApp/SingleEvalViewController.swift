//
//  SingleEvalViewController.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 5/28/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import UIKit

class SingleEvalViewController: UIViewController {
    var me: Player = Me!
    
    @IBOutlet var imageView: UIImageView!
    var image: UIImage!
    @IBOutlet var questionLabel: UILabel!
    
    @IBAction func yesButtonTapped(_ sender: Any) {
    }
    @IBAction func noButtonTapped(_ sender: Any) {
    }
    @IBAction func cantTellTapped(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Set the image
        self.imageView.image = self.image
        
        if self.image != nil{
            applyVisibilityGradient()
        }
        
    }
    
    func applyVisibilityGradient(){
        // Visibility background
        let gradient = CAGradientLayer()
        gradient.frame = self.imageView.bounds
        
        let dark = UIColor(white: 0.0, alpha: 0.3).cgColor
        let light = UIColor(white: 0.0, alpha: 0.1).cgColor
        let clear = UIColor(white: 0.5, alpha: 0.0).cgColor
        
        gradient.colors = [dark, clear, clear, light, dark]
        
        self.imageView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("SingleEvalVC Appearing")
    }
    
    
    
}
