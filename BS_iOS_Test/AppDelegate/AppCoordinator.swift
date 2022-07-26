//
//  AppCoordinator.swift
//  Tmmim
//
//  Created by Jamil Bin Hossain on 3/5/21.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
       print("AppCoordinator1")
    
        let movieListCoordinator = MovieListVCCoordinator(window: self.window)
        movieListCoordinator.start()
    }
    
    func popViewController() {
        
    }
    
}
