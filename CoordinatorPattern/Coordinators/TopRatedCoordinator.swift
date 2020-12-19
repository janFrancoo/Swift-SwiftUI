//
//  TopRatedCoordinator.swift
//  CoordinatorPatternExample
//
//  Created by JanFranco on 9.12.2020.
//

import UIKit

protocol TopRatedFlow: class {
    func coordinateToDetail()
}

class TopRatedCoordinator: Coordinator, TopRatedFlow {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let topRatedViewController = TopRatedViewController()
        topRatedViewController.coordinator = self
        
        navigationController.pushViewController(topRatedViewController, animated: false)
    }
    
    // MARK: - Flow Methods
    func coordinateToDetail() {
        let topRatedDetailCoordinator = TopRatedDetailCoordinator(navigationController: navigationController)
        coordinate(to: topRatedDetailCoordinator)
    }
    
}
