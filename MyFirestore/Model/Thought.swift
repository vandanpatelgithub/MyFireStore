//
//  Thought.swift
//  MyFirestore
//
//  Created by Patel, Vandan (ETW - FLEX) on 4/13/18.
//  Copyright © 2018 Patel, Vandan (ETW - FLEX). All rights reserved.
//

import Foundation

struct Thought: Codable {
    let category: String
    let numComments: Int
    let numLikes: Int
    let thoughtText: String
    let timestamp: Date
    let username: String
    let documentID: String?
}
