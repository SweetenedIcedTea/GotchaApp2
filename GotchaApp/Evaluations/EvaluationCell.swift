//
//  EvaluationCell.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 5/16/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import UIKit

class EvaluationCell: UITableViewCell{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var targetImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        timeLabel.adjustsFontForContentSizeCategory = true
//        valueLabel.adjustsFontForContentSizeCategory = true
    }
}
