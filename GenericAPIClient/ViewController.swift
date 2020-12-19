//
//  ViewController.swift
//  GenericAPIClientExample
//
//  Created by JanFranco on 14.12.2020.
//

import UIKit
import Combine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catFactProvider: CatFactProvider! = CatFactAPI()
        
        /*
        catFactProvider.randomFact {
            switch $0 {
            case .failure(_):
                print("failed")
            case let .success(fact):
                print("success")
                print(fact.text ?? "")
            }
        }
        */
        
        var publishers = [AnyCancellable]()
        
        catFactProvider.randomFact()
            .map { $0.text }
            .sink(receiveCompletion: { _ in print("error") }, receiveValue: { print($0 ?? "def") })
            .store(in: &publishers)

    }


}

