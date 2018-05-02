//
//  AddThoughVC.swift
//  MyFirestore
//
//  Created by Patel, Vandan (ETW - FLEX) on 4/10/18.
//  Copyright © 2018 Patel, Vandan (ETW - FLEX). All rights reserved.
//

import UIKit
import Firebase

class AddThoughVC: UIViewController, Storyboard {

    weak var coordinator: MainCoordinator?

    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var thoughtTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!


    var selectedCategory = Category.funny.rawValue

    override func viewDidLoad() {
        super.viewDidLoad()
        thoughtTextView.delegate = self
    }

    @IBAction func didTapPost(_ sender: UIButton) {
        guard let username = usernameTextField.text else { return }
        let thought = Thought(category: selectedCategory, numComments: 0, numLikes: 0, thoughtText: thoughtTextView.text,
                              timestamp: Date(), username: username, documentID: "")
        
        do {
            let data = try JSONEncoder().encode(thought)
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let dict = jsonDict as? [String: Any] else { return }
            collectionRef.addDocument(data: dict) { (error) in
                guard error != nil else {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
            }
        } catch let error {
            debugPrint("Error Encoding Data: \(error.localizedDescription)")
        }
    }

    
    @IBAction func didTapCategory(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: selectedCategory = Category.funny.rawValue
        case 1: selectedCategory = Category.serious.rawValue
        case 2: selectedCategory = Category.crazy.rawValue
        default: break
        }
    }
}

enum Category: String {
    case funny, serious, crazy, popular
}

let collectionRef = Firestore.firestore().collection(ColletionNames.thoughts.rawValue)

enum ColletionNames: String {
    case thoughts
}

extension AddThoughVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        thoughtTextView.text = ""
        thoughtTextView.textColor = .darkGray
    }
}
