//
//  ViewController.swift
//  BuilderPatternExample
//
//  Created by JanFranco on 10.12.2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    private func getData() {
        let requestBuilder = RequestBuilder()
        requestBuilder.setBaseUrl(RequestBaseUrls.gitHub)
        requestBuilder.setEndpoint(RequestEndpoints.searchRepositories)
        requestBuilder.setMethod(.GET)
        requestBuilder.addHeader("Content-Type", "application/json")
        requestBuilder.addParameter("q", "Builder Design Pattern")
        
        let request = requestBuilder.build()
        
        let taskBuilder = TaskBuilder()
        taskBuilder.setRequest(request)
        
        let task = taskBuilder.build()
        task.resume()
    }
    
}
