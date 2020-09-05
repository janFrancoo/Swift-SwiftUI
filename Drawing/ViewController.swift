//
//  ViewController.swift
//  DrawingTest
//
//  Created by JanFranco on 5.09.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var drawView: DrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    @objc func save(_ sender: UIButton) {
        let image = drawView.exportDrawing()
    }

}
