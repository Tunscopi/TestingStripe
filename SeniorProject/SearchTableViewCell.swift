//
//  SearchTableViewCell.swift
//  SeniorProject
//
//  Created by Maalik Hornbuckle on 12/5/16.
//  Copyright © 2016 blah. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet var businessLabel: UILabel!
    @IBOutlet var ownerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
