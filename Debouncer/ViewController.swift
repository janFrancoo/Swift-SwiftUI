//
//  ViewController.swift
//  DebouncerExample
//
//  Created by JanFranco on 8.12.2020.
//

import UIKit
import PKHUD
import SwipeView
import RSSelectionMenu
import SwiftEventBus

class ViewController: UIViewController, SwipeViewDataSource, SwipeViewDelegate {
    
    private let debouncer = Debouncer(timeInterval: 3)
    private let network = Network()
    private var items: [UIView] = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        checkNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
    }
    
    private func setupUI() {
        let screenSize: CGRect = UIScreen.main.bounds
        
        // SwipeView
        let swipeView = SwipeView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        swipeView.delegate = self
        swipeView.dataSource = self
        self.view.addSubview(swipeView)
        
        // First View
        let firstView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        firstView.backgroundColor = .red
        items.append(firstView)
        
        // Label
        let label = UILabel()
        label.text = "Waiting..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Halvetica", size: 17)
        firstView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: firstView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: screenSize.width * 0.25).isActive = true
        label.heightAnchor.constraint(equalToConstant: screenSize.height * 0.10).isActive = true
        
        // Second View
        let secondView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        secondView.backgroundColor = .green
        items.append(secondView)
        
        // ClickMeButton
        let clickMeButton = UIButton()
        clickMeButton.backgroundColor = .blue
        clickMeButton.setTitle("Click Me", for: .normal)
        clickMeButton.addTarget(self, action: #selector(clickMeButtonClicked), for: .touchUpInside)
        secondView.addSubview(clickMeButton)
        
        clickMeButton.translatesAutoresizingMaskIntoConstraints = false
        clickMeButton.centerXAnchor.constraint(equalTo: secondView.centerXAnchor).isActive = true
        clickMeButton.centerYAnchor.constraint(equalTo: secondView.centerYAnchor).isActive = true
        clickMeButton.widthAnchor.constraint(equalToConstant: screenSize.width * 0.25).isActive = true
        clickMeButton.heightAnchor.constraint(equalToConstant: screenSize.height * 0.10).isActive = true
        
        // Third View
        let thirdView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        thirdView.backgroundColor = .blue
        items.append(thirdView)
        
        // SelectButton
        let selectButton = UIButton()
        selectButton.backgroundColor = .green
        selectButton.setTitle("Select", for: .normal)
        selectButton.addTarget(self, action: #selector(selectButtonClicked), for: .touchUpInside)
        thirdView.addSubview(selectButton)
        
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.centerXAnchor.constraint(equalTo: thirdView.centerXAnchor).isActive = true
        selectButton.centerYAnchor.constraint(equalTo: thirdView.centerYAnchor).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: screenSize.width * 0.25).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: screenSize.height * 0.10).isActive = true
        
        // HUD
        HUD.show(.progress, onView: self.view)
        
        SwiftEventBus.onMainThread(self, name: "jan_franco") { result in
            label.text = "Wowww..."
        }
    }
    
    @objc private func clickMeButtonClicked(_ sender: UIButton) {
        debouncer.renewInterval()
        debouncer.handler = {
            print("handler called!!!")
        }
    }
    
    @objc private func selectButtonClicked(_ sender: UIButton) {
        let options = ["New York", "London", "Istanbul", "Moscow", "Berlin", "Paris", "Beijing", "Tokyo"]
        
        let dropdown = RSSelectionMenu(dataSource: options) { (cell, item, IndexPath) in
            cell.textLabel?.text = item
        }

        dropdown.setSelectedItems(items: []) { (item, index, isSelected, selectedItems) in
            print(selectedItems)
        }
        
        dropdown.show(style: .push, from: self)
    }
    
    private func checkNetwork() {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(3)) {
            if self.network.isNetworkAvailable() {
                DispatchQueue.main.async {
                    HUD.flash(.success, onView: self.view, delay: 1.0)
                }
            } else {
                DispatchQueue.main.async {
                    HUD.flash(.error, onView: self.view, delay: 1.0)
                }
            }
        }
    }
    
    func numberOfItems(in swipeView: SwipeView!) -> Int {
        return items.count
    }
    
    func swipeView(_ swipeView: SwipeView!, viewForItemAt index: Int, reusing view: UIView!) -> UIView! {
        return items[index]
    }

}
