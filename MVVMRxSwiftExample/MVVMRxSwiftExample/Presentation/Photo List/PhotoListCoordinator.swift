//
//  PhotoListCoordinator.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 28.05.2021.
//

import UIKit

protocol PhotoListCoordinator: class {
    func pushToDetail(with photoId: String)
}

class PhotoListCoordinatorImpl: Coordinator {
    
    unowned let navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func start() {
        let photoListViewController = PhotoListViewController()
        let photoListViewmodel = PhotoListViewModelImpl(
            photosService: UnsplashPhotosServiceImpl(),
            photoLoadingService: DataLoadingServiceImpl(),
            dataToImageService: DataToImageConversionServiceImpl(),
            coordinator: self
        )
        photoListViewController.viewModel = photoListViewmodel
        
        navController.pushViewController(photoListViewController, animated: true)
    }
}

extension PhotoListCoordinatorImpl: PhotoListCoordinator {
    func pushToDetail(with photoId: String) {
        let photoDetailCoordinator = PhotoDetailCoordinatorImplementation(
            navigationController: navController,
            photoId: photoId
        )
        
        coordinate(to: photoDetailCoordinator)
    }
}
