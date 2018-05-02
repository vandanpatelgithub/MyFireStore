//
//  MainCoordinator.swift
//  MyFirestore
//
//  Created by Patel, Vandan (ETW - FLEX) on 5/1/18.
//  Copyright © 2018 Patel, Vandan (ETW - FLEX). All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = MainVC.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func addThought() {
        let vc = AddThoughVC.instantiate()
        vc.coordinator =  self
        navigationController.pushViewController(vc, animated: true)
    }
}
