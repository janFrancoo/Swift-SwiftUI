//
//  ViewController.swift
//  AlertProject
//
//  Created by JanFranco on 26.01.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var passAgainField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUp(_ sender: Any) {
        if usernameField.text == "" {
            makeAlert(title: "Fail", message: "Where is username?")
        }
        else if passField.text != passAgainField.text || passField.text == "" || passAgainField.text == "" {
            makeAlert(title: "Fail", message: "Enter passwords correctly!")
        }
        else {
            makeAlert(title: "Success", message: "Welcome \(usernameField.text!)")
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
