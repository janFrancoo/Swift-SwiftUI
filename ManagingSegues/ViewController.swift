//
//  ViewController.swift
//  SegueTutorial
//
//  Created by JanFranco on 26.01.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var userName = ""
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad func called")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear func called")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear func called")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear func called")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear func called")
    }

    @IBAction func next(_ sender: Any) {
        userName = textField.text!
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondVC" {
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.name = userName
        }
    }
    
}

