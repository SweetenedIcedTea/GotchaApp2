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
    var imagesLoaded: Bool = false {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 130
        tableView.estimatedRowHeight = 130
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
        imagesLoaded = false
        getEvaluations()
        getImages()
    }
    
    func getEvaluations(){
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
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
                    
                }
                print("evaluations reloaded")
                self.tableView.reloadData()
            }
            
        })
    }
    
    func getImages(){
        //            let pathReference = self.storage.reference(withPath: "images/evalFor\(targetUserName).png")
        self.images = []
        let pathReference = self.storage.reference(withPath: "images/eval.png")
        
        pathReference.getData(maxSize: 15 * 1024 * 1024, completion: { (data, error) in
            if let error = error{
                print("error loading image:")
                print(error)
            } else {
                if let image = UIImage(data: data!){
                    self.images.append(image)
                    print("image appended")
                    print(self.images)
                    self.imagesLoaded = true
                }
            }
        })
    }
    
    func correctedImage(_ image: UIImage) -> UIImage{
        let reorientedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
        
        //crop image
        let width = reorientedImage.cgImage!.width
        let height = reorientedImage.cgImage!.height
        //true size is 720x720
        let cropRegion = CGRect(origin: CGPoint(x: (width/2)-500, y: (height/2)-500), size: CGSize(width: 1000, height: 1000))
        let croppedCGImage = reorientedImage.cgImage?.cropping(to: cropRegion)
        
        return UIImage(cgImage: croppedCGImage!, scale: 1.0, orientation: .right)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "evaluationCell", for: indexPath) as! EvaluationCell
        
        //get the evaluation at indexPath.row
        let eval = evaluations[indexPath.row]
        
        var image: UIImage? = nil
        
        if imagesLoaded == true {
            image = correctedImage(images[indexPath.row])
        } else {
            print("images not loaded")
        }
        
        //Configure the cell
        cell.nameLabel.text = eval.targetUserName
        cell.timeLabel.text = Date(timeIntervalSince1970: eval.toInterval(eval.experation)).timeIntervalSince(Date()).description
        cell.targetImageView.image = image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluations.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier!
        switch id{
        case "showSingleVC":
            if let row = tableView.indexPathForSelectedRow?.row {
                
                
                if images.count > row {
                    let img = images[row]
                    
                    let reorientedImg = UIImage(cgImage: img.cgImage!, scale: 1.0, orientation: .right)
                    let SEVC = segue.destination as! SingleEvalViewController
                    SEVC.image = reorientedImg
                    
                    let eval = evaluations[row]
                    SEVC.evaluation = eval
                }
                
            }
            
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    @IBAction func unwindToEvaluations(unwindSegue: UIStoryboardSegue){
        print("unwind to Evals triggered")
    }
    
}
