//
//  AppDelegate.swift
//  VipExample
//
//  Created by JanFranco on 11.12.2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let titlesViewController = TitlesViewController()
        let navigationController = UINavigationController(rootViewController: titlesViewController)
        TitlesConfigurator.configureModule(viewController: titlesViewController)
        
        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
