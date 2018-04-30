//
//  ThoughtCell.swift
//  MyFirestore
//
//  Created by Patel, Vandan (ETW - FLEX) on 4/24/18.
//  Copyright © 2018 Patel, Vandan (ETW - FLEX). All rights reserved.
//

import UIKit
import Firebase

class ThoughtCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var thoughtTextLabel: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var likesNumberLabel: UILabel!

    private var thought: Thought!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestureRecognition()
    }

    func setupGestureRecognition() {
        likesImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.likedImage))
        tap.numberOfTapsRequired = 1
        likesImage.addGestureRecognizer(tap)
    }

    @objc func likedImage() {
        FirestoreService.addLikeFor(thought: self.thought)
    }

    func configureCell(thought: Thought) {
        self.thought = thought
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
