//
//  ViewController.swift
//  BasicCalculator
//
//  Created by JanFranco on 25.01.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var num1: UITextField!
    @IBOutlet weak var num2: UITextField!
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func add(_ sender: Any) {
        if let n1 = Int(num1.text!) {
            if let n2 = Int(num2.text!) {
                result.text = "Result = " + String(n1 + n2)
            } else {
                result.text = "Enter the second num!"
            }
        } else {
            result.text = "Enter the first num!"
        }
    }
    
    @IBAction func sub(_ sender: Any) {
        if let n1 = Int(num1.text!) {
            if let n2 = Int(num2.text!) {
                result.text = "Result = " + String(n1 - n2)
            } else {
                result.text = "Enter the second num!"
            }
        } else {
            result.text = "Enter the first num!"
        }
    }
    
    @IBAction func mult(_ sender: Any) {
        if let n1 = Int(num1.text!) {
            if let n2 = Int(num2.text!) {
                result.text = "Result = " + String(n1 * n2)
            } else {
                result.text = "Enter the second num!"
            }
        } else {
            result.text = "Enter the first num!"
        }
    }
    
    @IBAction func div(_ sender: Any) {
        if let n1 = Float(num1.text!) {
            if let n2 = Float(num2.text!) {
                result.text = "Result = " + String(n1 / n2)
            } else {
                result.text = "Enter the second num!"
            }
        } else {
            result.text = "Enter the first num!"
        }
    }
    
}

