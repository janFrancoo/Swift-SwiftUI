//
//  TitleDetailPresenter.swift
//  VipExample
//
//  Created by JanFranco on 11.12.2020.
//

import Foundation

protocol TitleDetailPresenterProtocol: class {
    func interactor(didRetrieveTitle title: Title)
    func interactor(didFailRetrieveTitle error: Error)
}

class TitleDetailPresenter: TitleDetailPresenterProtocol {
    
    var viewController: TitleDetailPresenterOutput?
    
    func interactor(didRetrieveTitle title: Title) {
        let titleString = title.text
        viewController?.presenter(didRetrieveItem: titleString ?? "")
    }
    
    func interactor(didFailRetrieveTitle error: Error) {
        viewController?.presenter(didFailRetrieveItem: error.localizedDescription)
    }
    
}
