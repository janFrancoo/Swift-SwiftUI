//
//  TitleDetailInteractor.swift
//  VipExample
//
//  Created by JanFranco on 11.12.2020.
//

import Foundation

protocol TitleDetailInteractorProtocol: class {
    var titleId: String? { get }
    
    func viewDidLoad()
}

class TitleDetailInteractor: TitleDetailInteractorProtocol {
    
    var titleId: String?
    
    var presenter: TitleDetailPresenter?
    
    private let titlesService = TitlesService()
    
    func viewDidLoad() {
        do {
            if let title = try titlesService.getTitle(with: self.titleId!) {
                presenter?.interactor(didRetrieveTitle: title)
            }
        } catch {
            presenter?.interactor(didFailRetrieveTitle: error)
        }
    }
}
