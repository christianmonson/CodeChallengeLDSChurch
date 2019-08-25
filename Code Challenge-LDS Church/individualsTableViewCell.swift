//
//  individualsTableViewCell.swift
//  Code Challenge-LDS Church
//
//  Created by Christian R Monson on 8/22/19.
//  Copyright © 2019 christianrmonson. All rights reserved.
//

import UIKit

class individualsTableViewCell: UITableViewCell {

    @IBOutlet weak var individualImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var affiliationLabel: UILabel!
    @IBOutlet weak var affiliationImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorners()
        // Initialization code
    }
    
    func roundCorners() {
        self.individualImageView.layer.cornerRadius = self.individualImageView.frame.height / 2
        self.individualImageView.clipsToBounds = true
        
        self.affiliationImageView.layer.cornerRadius = self.affiliationImageView.frame.height / 2
        self.affiliationImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
