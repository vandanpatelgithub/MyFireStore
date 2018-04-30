//
//  FireStoreService.swift
//  MyFirestore
//
//  Created by Patel, Vandan (ETW - FLEX) on 4/29/18.
//  Copyright © 2018 Patel, Vandan (ETW - FLEX). All rights reserved.
//

import Foundation
import Firebase

class FirestoreService {
    static func addLikeFor(thought: Thought) {
        Firestore.firestore().collection(ColletionNames.thoughts.rawValue)
            .document(thought.documentID!).setData([ThoughtKeys.numLikes.rawValue : thought.numLikes + 1],
                                                   options: SetOptions.merge()) { (error) in
                                                    if error != nil {
                                                        debugPrint("Error adding likes : \(String(describing: error?.localizedDescription))")
                                                    }
        }
    }
}
