//
//  TitlesConfigurator.swift
//  VipExample
//
//  Created by JanFranco on 11.12.2020.
//

import UIKit

class TitlesConfigurator {
    
    static func configureModule(viewController: TitlesViewController) {
        let view = TitlesView()
        let router = TitlesRouter()
        let interactor = TitlesInteractor()
        let presenter = TitlesPresenter()
        
        viewController.titlesView = view
        viewController.router = router
        viewController.interactor = interactor
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.navigationController = viewController.navigationController
    }
        
}
