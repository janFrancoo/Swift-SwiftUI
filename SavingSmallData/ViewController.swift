//
//  ViewController.swift
//  SavingSmallData
//
//  Created by JanFranco on 26.01.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let storedName = UserDefaults.standard.object(forKey: "name") as? String {
            if let storedBirthday = UserDefaults.standard.object(forKey: "birthday") as? String {
                label.text = "Name: \(storedName) Birthday: \(storedBirthday)"
            }
        }
    }
    
    @IBAction func save(_ sender: Any) {
        let name = textField1.text!
        let birthday = textField2.text!
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(birthday, forKey: "birthday")
        label.text = "Name: \(name) Birthday: \(birthday)"
    }

    @IBAction func deleteValues(_ sender: Any) {
        let storedName = UserDefaults.standard.object(forKey: "name")
        let storedBirthday = UserDefaults.standard.object(forKey: "birthday")
        
        if (storedName as? String) != nil && (storedBirthday as? String) != nil {
            UserDefaults.standard.removeObject(forKey: "name")
            UserDefaults.standard.removeObject(forKey: "birthday")
            label.text = "Name:   Birthday:   "
        }
    }
}
