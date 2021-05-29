//
//  PhotoCollectionViewCell.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 29.05.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.center = self.contentView.center
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    
}

extension PhotoCollectionViewCell {
    private func setupUI() {
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
