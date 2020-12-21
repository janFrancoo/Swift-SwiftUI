//
//  TitleDetailViewController.swift
//  VipExample
//
//  Created by JanFranco on 11.12.2020.
//

import UIKit

protocol TitleDetailPresenterOutput: class {
    func presenter(didRetrieveItem item: String)
    func presenter(didFailRetrieveItem message: String)
}

class TitleDetailViewController: UIViewController {

    override func loadView() {
        super.loadView()
        self.view = titleDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor?.viewDidLoad()
    }
    
    // MARK: Properties
    var titleDetailView: TitleDetailView?
    var interactor: TitleDetailInteractor?
    weak var presenter: TitleDetailPresenter?

}

extension TitleDetailViewController: TitleDetailPresenterOutput {
    func presenter(didRetrieveItem item: String) {
        titleDetailView?.updateLabel(with: item)
    }
    
    func presenter(didFailRetrieveItem message: String) {
        // showError(with: message)
    }
}
