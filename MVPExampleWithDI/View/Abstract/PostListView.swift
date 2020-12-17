//
//  PostListView.swift
//  MVPExample
//
//  Created by JanFranco on 17.12.2020.
//

import Foundation

protocol PostListView {
    func onPostsRetrievalSuccess(posts: [Post])
    func onPostsRetrievalFailure(errorMessage: String)
}
