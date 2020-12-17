//
//  PostListViewPresenterr.swift
//  MVPExample
//
//  Created by JanFranco on 17.12.2020.
//

import Foundation

protocol PostListViewPresenter: class {
    init(view: PostListView, postService: PostService)
    func viewDidLoad()
}
