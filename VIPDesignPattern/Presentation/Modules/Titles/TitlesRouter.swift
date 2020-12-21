//
//  TitlesRouter.swift
//  VipExample
//
//  Created by JanFranco on 11.12.2020.
//

import UIKit

protocol TitlesRouterProtocol: class {
    var navigationController: UINavigationController? { get }
    
    func routeToDetail(with id: String)
}

class TitlesRouter: TitlesRouterProtocol {
    weak var navigationController: UINavigationController?
    
    func routeToDetail(with id: String) {
        let viewController = TitleDetailViewController()
        TitleDetailConfigurator.configureModule(titleId: id,
                                                viewController: viewController)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
