//
//  ViewController.swift
//  MyFirestore
//
//  Created by Patel, Vandan (ETW - FLEX) on 4/9/18.
//  Copyright © 2018 Patel, Vandan (ETW - FLEX). All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController, Storyboard {

    weak var coordinator: MainCoordinator?

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
                if self?.selectedCategory == Category.popular.rawValue {
                    self?.fetchPopularThoughts()
                } else {
                    if let error = error {
                        debugPrint("Error fetching documents: \(error)")
                    } else {
                        guard let snap = snapshot, let strongSelf = self else { return }
                        strongSelf.parseData(strongSelf, snap)
                        DispatchQueue.main.async { strongSelf.tableView.reloadData() }
                    }
                }
        }
    }

    fileprivate func fetchPopularThoughts() {
        collectionRef
            .order(by: ThoughtKeys.numLikes.rawValue, descending: true)
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    debugPrint("Error fetching documents: \(error)")
                } else {
                    guard let snap = snapshot, let strongSelf = self else { return }
                    strongSelf.parseData(strongSelf, snap)
                    DispatchQueue.main.async { strongSelf.tableView.reloadData() }
                }
        }
    }

    fileprivate func parseData(_ strongSelf: MainVC, _ snap: QuerySnapshot) {
        strongSelf.thoughts.removeAll()
        for document in snap.documents {
            do {
                let data    = try JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted)
                var thought = try JSONDecoder().decode(Thought.self, from: data)
                thought.documentID = document.documentID
                strongSelf.thoughts.append(thought)
            } catch let error {
                debugPrint("Error Parsing Data: \(error)")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        selectedCategory == Category.popular.rawValue ? fetchPopularThoughts() :
            fetchThoughts(forCategory: Category.funny)
    }

    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: selectedCategory = Category.funny.rawValue
        case 1: selectedCategory = Category.serious.rawValue
        case 2: selectedCategory = Category.crazy.rawValue
        case 3: selectedCategory = Category.popular.rawValue
        default: break
        }
        guard let category = Category(rawValue: selectedCategory) else { return }
        selectedCategory == Category.popular.rawValue ? fetchPopularThoughts() : fetchThoughts(forCategory: category)
    }

    @IBAction func addThought(_ sender: UIBarButtonItem) {
        coordinator?.addThought()
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

