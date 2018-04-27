//
//  ThoughtCell.swift
//  MyFirestore
//
//  Created by Patel, Vandan (ETW - FLEX) on 4/24/18.
//  Copyright © 2018 Patel, Vandan (ETW - FLEX). All rights reserved.
//

import UIKit

class ThoughtCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var thoughtTextLabel: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var likesNumberLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(thought: Thought) {
        usernameLabel.text      = thought.username
        timestampLabel.text     = thought.timestamp.toString()
        thoughtTextLabel.text   = thought.thoughtText
        likesNumberLabel.text   = "\(thought.numLikes)"
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "MM/dd/yy h:mm a"
        return dateFormatter.string(from: self)
    }
}
