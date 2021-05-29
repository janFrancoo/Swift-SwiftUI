//
//  AppCoordinator.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 28.05.2021.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navController = UINavigationController()
        if #available(iOS 13.0, *) {
            navController.overrideUserInterfaceStyle = .light
        }
        window.rootViewController = navController
        window.makeKeyAndVisible()
        	
        let photoListCoordinator = PhotoListCoordinatorImpl(navController: navController)
        coordinate(to: photoListCoordinator)
    }
}
