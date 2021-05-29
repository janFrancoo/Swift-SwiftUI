//
//  PhotoDetailCoordinator.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 29.05.2021.
//

import UIKit

protocol PhotoDetailCoordinator: class {}

class PhotoDetailCoordinatorImplementation: Coordinator {
    
    unowned let navigationController: UINavigationController
    let photoId: String
    
    init(navigationController: UINavigationController, photoId: String) {
        self.navigationController = navigationController
        self.photoId = photoId
    }
    
    func start() {
        let photoDetailViewController = PhotoDetailViewController()
        // let viewModel = ..ViewModel(.., photoId: photoId)
        // photoDetailViewController.viewModel = viewModel
        photoDetailViewController.photoId = photoId
        navigationController.pushViewController(photoDetailViewController, animated: true)
    }
}

extension PhotoDetailCoordinatorImplementation: PhotoDetailCoordinator {}
