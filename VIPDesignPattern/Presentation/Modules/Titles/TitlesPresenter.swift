//
//  TitlesPresenter.swift
//  VipExample
//
//  Created by JanFranco on 11.12.2020.
//

import Foundation

protocol TitlesPresenterProtocol: class {
    func interactor(didRetrieveTitles titles: [Title])
    func interactor(didFailRetrieveTitles error: Error)
    
    func interactor(didAddTitle title: Title)
    func interactor(didFailAddTitle error: Error)
    
    func interactor(didDeleteTitleAtIndex index: Int)
    func interactor(didFailDeleteTitleAtIndex index: Int)
    
    func interactor(didFindTitle title: Title)
}

class TitlesPresenter: TitlesPresenterProtocol {
    weak var viewController: TitlesPresenterOutput?
    
    func interactor(didRetrieveTitles titles: [Title]) {
        let titlesStrings = titles.compactMap { $0.text }
        viewController?.presenter(didRetrieveItems: titlesStrings)
    }
    
    func interactor(didFailRetrieveTitles error: Error) {
        viewController?.presenter(didFailRetreiveItems: error.localizedDescription)
    }
    
    func interactor(didAddTitle title: Title) {
        if let titleString = title.text {
            viewController?.presenter(didAddItem: titleString)
        }
    }
    
    func interactor(didDeleteTitleAtIndex index: Int) {
        viewController?.presenter(didDeleteAtItemIndex: index)
    }
    
    func interactor(didFailDeleteTitleAtIndex index: Int) {
        viewController?.presenter(didFailDeleteAtItemIndex: index, message: "Couldn't delete")
    }
    
    func interactor(didFailAddTitle error: Error) {
        viewController?.presenter(didFailAddItem: error.localizedDescription)
    }
    
    func interactor(didFindTitle title: Title) {
        if let id = title.id {
            viewController?.presenter(didObtainItemId: id)
        }
    }
}
