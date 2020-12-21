//
//  TitleDetailConfigurator.swift
//  VipExample
//
//  Created by JanFranco on 11.12.2020.
//

import Foundation

class TitleDetailConfigurator {
    
    static func configureModule(titleId: String,
                                viewController: TitleDetailViewController) {
        let view = TitleDetailView()
        let interactor = TitleDetailInteractor()
        let presenter = TitleDetailPresenter()
        
        interactor.titleId = titleId
        
        viewController.titleDetailView = view
        viewController.interactor = interactor
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
    }
}
