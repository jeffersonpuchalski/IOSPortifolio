//
//  UserRepoCell.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 19/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import UIKit

class UserRepoCell: UITableViewCell {
    
    @IBOutlet weak var repoOwnerLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    
    func setup(repoName: String, owner: String){
        self.repoOwnerLabel.text = repoName
        self.repoNameLabel.text = owner
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
