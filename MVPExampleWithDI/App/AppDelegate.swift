//
//  AppDelegate.swift
//  MVPExample
//
//  Created by JanFranco on 17.12.2020.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let container: Container = {
        let container = Container()
        
        container.register(NetworkService.self) { _ in AlamoClient() }
        container.register(PostService.self) { r in
            PostsServiceImp(networkService: r.resolve(NetworkService.self)!)
        }
        container.register(PostListView.self) { _ in PostListViewController() }
        container.register(PostListViewPresenter.self) { r in
            let presenter = PostListViewPresenterImp(
                view: r.resolve(PostListView.self)!,
                postService: r.resolve(PostService.self)!)
            return presenter
        }
        container.register(PostListViewController.self) { r in
            let vc = PostListViewController()
            vc.presenter = r.resolve(PostListViewPresenter.self)
            return vc
        }
        
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: container.resolve(PostListViewController.self)!)
        window?.makeKeyAndVisible()
        return true
    }
    
}
