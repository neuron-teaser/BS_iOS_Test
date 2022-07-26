//
//  Coordinator.swift
//  Tmmim
//
//  Created by Jamil Bin Hossain on 3/5/21.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] {get}
    func start()
    func popViewController()
}
