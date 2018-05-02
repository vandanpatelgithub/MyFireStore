//
//  Coordinator.swift
//  MyFirestore
//
//  Created by Patel, Vandan (ETW - FLEX) on 5/1/18.
//  Copyright © 2018 Patel, Vandan (ETW - FLEX). All rights reserved.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
