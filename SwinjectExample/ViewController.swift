//
//  ViewController.swift
//  SwinjectExample
//
//  Created by JanFranco on 16.12.2020.
//

import UIKit

class ViewController: UIViewController {

    var weatherFetcher: WeatherFetcher?
    
    fileprivate var cities = [City]() {
        didSet {
            for city in cities {
                print(city.id, city.name, city.weather)
            }
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        weatherFetcher?.fetch {
            if let cities = $0 {
                self.cities = cities
            }
            else {
                let title = "Error"
                let message = "Cannot communicate with the weather server. Check wi-fi or cellular network settings."
                let dismiss = "Dismiss"
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: dismiss, style: .default) { _ in
                    alert.dismiss(animated: true, completion: nil)
                })
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}

