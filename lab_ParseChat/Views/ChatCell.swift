//
//  ChatCell.swift
//  lab_ParseChat
//
//  Created by PJ Martinez on 2/21/18.
//  Copyright © 2018 Paolo Martinez. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
