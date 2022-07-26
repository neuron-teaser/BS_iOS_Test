//
//  MovieListVCCoordinator.swift
//  BS-iOS-Test
//
//  Created by Jamil Bin Hossain on 6/5/21.
//

import UIKit

class MovieListVCCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    let navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let movieVC: MovieListVC = .instantiate(storyBoard: StoryBoard.movie.name)
        movieVC.coordinator = self
        navigationController.pushViewController(movieVC, animated: true)
        
        window.rootViewController = movieVC
        window.makeKeyAndVisible()
    }
    
    func popViewController() {
        
    }
    

}
