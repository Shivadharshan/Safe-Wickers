//
//  BeachListTableViewCell.swift
//  Safe Wickers
//
//  Created by 匡正 on 20/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit

class BeachListTableViewCell: UITableViewCell {

    @IBAction func likeBeach(_ sender: Any) {
    }

    @IBOutlet weak var riskImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var beachNameLabel: UILabel!
    @IBOutlet weak var beachImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
