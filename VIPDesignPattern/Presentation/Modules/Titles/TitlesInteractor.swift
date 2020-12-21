//
//  TitlesInteractor.swift
//  VipExample
//
//  Created by JanFranco on 11.12.2020.
//

import Foundation

protocol TitlesInteractorProtocol {
    func viewDidLoad()
    func addTapped(with text: String)
    func didSelectRow(at index: Int)
    func didCommitDelete(for index: Int)
}

class TitlesInteractor: TitlesInteractorProtocol {
    
    var presenter: TitlesPresenterProtocol?
    
    private let titlesService = TitlesService()
    private var titles: [Title] = []
    
    func viewDidLoad() {
        do {
            self.titles = try titlesService.getTitles()
            presenter?.interactor(didRetrieveTitles: self.titles)
        } catch {
            presenter?.interactor(didFailRetrieveTitles: error)
        }
    }
    
    func addTapped(with text: String) {
        do {
            let title = try titlesService.addTitle(text: text)
            self.titles.append(title)
            
            presenter?.interactor(didAddTitle: title)
        } catch {
            presenter?.interactor(didFailAddTitle: error)
        }
    }
    
    func didSelectRow(at index: Int) {
        if self.titles.indices.contains(index) {
            presenter?.interactor(didFindTitle: self.titles[index])
        }
    }
    
    func didCommitDelete(for index: Int) {
        do {
            try titlesService.deleteTitle(with: self.titles[index].id!)
            self.titles.remove(at: index)
            presenter?.interactor(didDeleteTitleAtIndex: index)
        } catch {
            presenter?.interactor(didFailDeleteTitleAtIndex: index)
        }
    }
}
