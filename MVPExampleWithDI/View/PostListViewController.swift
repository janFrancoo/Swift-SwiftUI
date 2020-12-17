//
//  TodoListViewController.swift
//  MVPExample
//
//  Created by JanFranco on 17.12.2020.
//

import UIKit
import PKHUD

class PostListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    var posts: [Post] = []
    var presenter: PostListViewPresenter!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor = .darkGray
        label.text = "No posts here"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

}

extension PostListViewController: PostListView {
    func onPostsRetrievalSuccess(posts: [Post]) {
        HUD.flash(.success, delay: 1.0)
        self.posts = posts
        
        if self.posts.count != 0 {
            self.placeholderLabel.isHidden = true
        }
        
        self.tableView.reloadData()
    }
    
    func onPostsRetrievalFailure(errorMessage: String) {
        HUD.flash(.error, delay: 1.0)
        self.placeholderLabel.text = errorMessage
    }
}

extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
    
}

extension PostListViewController {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        self.view.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            placeholderLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        HUD.show(.progress)
    }
}
