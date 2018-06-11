//
//  EvaluationsViewController.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 4/25/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import UIKit
import Firebase

class EvaluationsViewController: UITableViewController {
    var me: Player = Me!
    let ref = Database.database().reference(withPath: "all-evaluations")
    let storage = Storage.storage()
    var evaluations = [Evaluation]()
    var images = [UIImage]()
    var imageDictionary = [String: UIImage]() {
        didSet {
            if imageDictionary.count == evaluations.count{
                self.imagesLoaded = true
            }
        }
    }
    var imagesLoaded: Bool = false
    
    //Timer
    var timer = Timer()
    var timerIsRunning = false //a way to keep track if the timer is running
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        if imagesLoaded{
            reload()
        }
    }
    
    func startTimer(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(EvaluationsViewController.refreshTime), userInfo: nil, repeats: true)
    }
    
    @objc func refreshTime(){
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 130
        tableView.estimatedRowHeight = 130
        reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("EvaluationsViewController Appearing")
        
        startTimer()
    }
    
    func reload(){
        imagesLoaded = false
        evaluations = []
        getEvaluations()
    }
    
    func getEvaluations(){
        print("getting Evaluations")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            if value == nil || value?.count == 0{
                return
            }
            for eval in value!{
                let evalProperty = eval.value as? [String: Any]
                
                var numVotes = 0
                var rating = 0.0
                var targetUserName = ""
                var exp = Date()
                
                for property in evalProperty!{
                    switch property.key{
                    case "numVotes":
                        numVotes = property.value as! Int
                    case "targetUserName":
                        targetUserName = property.value as! String
                    case "rating":
                        rating = property.value as! Double
                    case "experation":
                        exp = Date(timeIntervalSince1970: (property.value as! TimeInterval))
                    default:
                        print("error: unrecognized evaluation property key- \(property.key)")
                    }
                }
                
                let newEval = Evaluation(targetUserName: targetUserName, exp: exp)
                newEval.numVotes = numVotes
                newEval.rating = rating
                
                if !self.evaluations.contains(newEval){
                    self.evaluations.append(newEval)
                    print("appended eval for \(targetUserName)")
                }
                
                self.tableView.reloadData()
            }
            self.getImages()
        })
        
    }
    
    func getImages(){
        print("getting images")
        self.imageDictionary = [:]
        for eval in evaluations{
            let name = eval.targetUserName
            print("attempting to get image: images/evalFor\(name).png")
            let pathReference = self.storage.reference(withPath: "images/evalFor\(name).png")
            
            pathReference.getData(maxSize: 15 * 1024 * 1024, completion: { (data, error) in
                if let error = error{
                    print("error loading image:")
                    print(error)
                } else {
                    if let image = UIImage(data: data!){
                        self.imageDictionary[name] = image
                        print("image for \(name) added")
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
    }
    
    func correctedImage(_ image: UIImage) -> UIImage{
        let reorientedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
        
        //crop image
        let width = reorientedImage.cgImage!.width
        let height = reorientedImage.cgImage!.height
        //true size is 720x720
        let cropRegion = CGRect(origin: CGPoint(x: (width/2)-840, y: (height/2)-620), size: CGSize(width: 1250, height: 1250))
        let croppedCGImage = reorientedImage.cgImage?.cropping(to: cropRegion)
        
        return UIImage(cgImage: croppedCGImage!, scale: 1.0, orientation: .right)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "evaluationCell", for: indexPath) as! EvaluationCell
        
        //get the evaluation at indexPath.row
        let eval = evaluations[indexPath.row]
        
        var image: UIImage? = nil
        
        if imageDictionary.keys.contains(eval.targetUserName){
            image = correctedImage(imageDictionary[eval.targetUserName]!)
        }
        
        //Configure the cell
        cell.nameLabel.text = eval.targetUserName
        cell.timeLabel.text = Date(timeIntervalSince1970: eval.toInterval(eval.experation)).timeIntervalSince(Date()).description
        let time = Date(timeIntervalSince1970: eval.toInterval(eval.experation)).timeIntervalSince(Date())
        
        cell.timeLabel.text = timeString(t: time)
        cell.targetImageView.image = image
        
        return cell
    }
    
    func timeString(t: TimeInterval) -> String{
        let roundedTime = Int(round(t))
        let hours = roundedTime / 3600
        var hoursString = String(hours)
        if hoursString.count == 1{
            hoursString = "0\(hours)"
        }
        let minutes = (roundedTime % 3600) / 60
        var minutesString = String(minutes)
        if minutesString.count == 1{
            minutesString = "0\(minutes)"
        }
        let seconds = (roundedTime % 3600) % 60
        var secondsString = String(seconds)
        if secondsString.count == 1{
            secondsString = "0\(seconds)"
        }
        
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluations.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier!
        switch id{
        case "showSingleVC":
            if let row = tableView.indexPathForSelectedRow?.row {
                let eval = evaluations[row]
                let name = eval.targetUserName
                let img: UIImage? = imageDictionary[name]
                let SEVC = segue.destination as! SingleEvalViewController
                
                if let image = img {
                    let reorientedImg = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
                    SEVC.image = reorientedImg
                }
                
                SEVC.name = name
                SEVC.evaluation = eval
                
            }
            
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    @IBAction func unwindToEvaluations(unwindSegue: UIStoryboardSegue){
        print("unwind to Evals triggered")
    }
    
}
