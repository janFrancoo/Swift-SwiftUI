//
//  PostListViewPresenter.swift
//  MVPExample
//
//  Created by JanFranco on 17.12.2020.
//

import Foundation

class PostListViewPresenterImp: PostListViewPresenter {
    
    private var view: PostListView
    private var postService: PostService

    required init(view: PostListView, postService: PostService) {
        self.view = view
        self.postService = postService
    }
    
    func viewDidLoad() {
        postService.getPosts {
            switch $0 {
            case let .failure(error):
                self.view.onPostsRetrievalFailure(errorMessage: error.localizedDescription)
            case let .success(posts):
                self.view.onPostsRetrievalSuccess(posts: posts)
            }
        }
    }
    
}
