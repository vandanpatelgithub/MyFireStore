//
//  ViewController.swift
//  MyFirestore
//
//  Created by Patel, Vandan (ETW - FLEX) on 4/9/18.
//  Copyright © 2018 Patel, Vandan (ETW - FLEX). All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    private var thoughts            = [Thought]()
    private var thoughtsListener: ListenerRegistration?
    private var selectedCategory = Category.funny.rawValue

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    fileprivate func fetchThoughts(forCategory category: Category) {
        collectionRef
            .whereField(ThoughtKeys.category.rawValue, isEqualTo: category.rawValue)
            .order(by: ThoughtKeys.timestamp.rawValue, descending: true)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    debugPrint("Error fetching documents: \(error)")
                } else {
                    guard let snap = snapshot, let strongSelf = self else { return }
                    strongSelf.thoughts.removeAll()
                    for document in snap.documents {
                        do {
                            let data    = try JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted)
                            let thought = try JSONDecoder().decode(Thought.self, from: data)
                            strongSelf.thoughts.append(thought)
                        } catch let error {
                            debugPrint("Error Parsing Data: \(error)")
                        }
                    }
                    DispatchQueue.main.async { strongSelf.tableView.reloadData() }
                }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchThoughts(forCategory: Category.funny)
    }

    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: selectedCategory = Category.funny.rawValue
        case 1: selectedCategory = Category.serious.rawValue
        case 2: selectedCategory = Category.crazy.rawValue
        case 4: selectedCategory = Category.popular.rawValue
        default: break
        }
        guard let category = Category(rawValue: selectedCategory) else { return }
        fetchThoughts(forCategory: category)
    }
    
    
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughts[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

