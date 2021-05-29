//
//  PhotoListViewController.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 28.05.2021.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: PhotoListViewModel!
    private var cachedImages: [Int: UIImage] = [:]
    
    lazy var photosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    lazy var bottomActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindCollectionView()
        bindLoadingState()
        bindBottomActivityIndicator()
        
        viewModel.viewDidLoad.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setupNavigationItem()
    }
}

extension PhotoListViewController {
    private func bindCollectionView() {
        viewModel.unsplashPhotos
            .bind(to: photosCollectionView.rx.items(
                cellIdentifier: PhotoCollectionViewCell.reuseIdentifier,
                cellType: PhotoCollectionViewCell.self
            )) { _, _, _ in }
            .disposed(by: disposeBag)
        
        photosCollectionView.rx.willDisplayCell
            .filter { $0.cell.isKind(of: PhotoCollectionViewCell.self) }
            .map { ($0.cell as! PhotoCollectionViewCell, $0.at.item) }
            .do(onNext: { (cell, index) in
                cell.imageView.image = nil
            })
            .subscribe(onNext: { [weak self] (cell, index) in
                if let cachedImage = self?.cachedImages[index] {
                    cell.imageView.image = cachedImage
                } else {
                    cell.activityIndicator.startAnimating()
                    self?.viewModel.willDisplayCellAtIndex.accept(index)
                }
            }).disposed(by: disposeBag)
        
        viewModel.imageRetrievedSuccess.observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (image, index) in
                if let cell = self?.photosCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? PhotoCollectionViewCell {
                    cell.activityIndicator.stopAnimating()
                    cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    UIView.animate(withDuration: 0.25) {
                        cell.transform = .identity
                    }
                    cell.imageView.image = image
                    self?.cachedImages[index] = image
                }
            }).disposed(by: disposeBag)
        
        viewModel.imageRetrievedError.observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] index in
                if let cell = self?.photosCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? PhotoCollectionViewCell {
                    cell.activityIndicator.stopAnimating()
                    cell.imageView.image = nil
                }
            }).disposed(by: disposeBag)
        
        photosCollectionView.rx.didEndDisplayingCell
            .map { $0.1 }
            .map { $0.item }
            .bind(to: viewModel.didEndDisplayingCellAtIndex)
            .disposed(by: disposeBag)
        
        photosCollectionView.rx.modelSelected(UnsplashPhoto.self)
            .compactMap { $0.id }
            .bind(to: viewModel.didChoosePhotoWithId)
            .disposed(by: disposeBag)
        
        photosCollectionView.rx.willDisplayCell
            .flatMap({ (_, indexPath) -> Observable<(section: Int, row: Int)> in
                return Observable.of((indexPath.section, indexPath.row))
            })
            .filter { (section, row) in
                let numberOfSections = self.photosCollectionView.numberOfSections
                let numberOfItems = self.photosCollectionView.numberOfItems(inSection: section)
                
                return section == numberOfSections - 1
                    && row == numberOfItems - 1
            }
            .map { _ in () }
            .bind(to: viewModel.didScrollToTheBottom)
            .disposed(by: disposeBag)
    }
    
    private func bindLoadingState() {
        viewModel.isLoadingFirstPage.observeOn(MainScheduler.instance)
            .map({ isLoading in
                return isLoading ? "Fetching..." : "Unsplash Photos"
            })
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func bindBottomActivityIndicator() {
        viewModel.isLoadingAdditionalPhotos
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] isLoading in
                self?.updateConstraintForMode(loadingMorePhotos: isLoading)
            })
            .bind(to: bottomActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

extension PhotoListViewController {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        self.view.addSubview(photosCollectionView)
        self.view.addSubview(bottomActivityIndicator)
        
        bottomConstraint = photosCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            photosCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            photosCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            photosCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomConstraint!
        ])
        
        NSLayoutConstraint.activate([
            bottomActivityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            bottomActivityIndicator.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomActivityIndicator.widthAnchor.constraint(equalToConstant: 44),
            bottomActivityIndicator.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    /// Changes photoCollectionView's bottom constraint with a subtle animation
    private func updateConstraintForMode(loadingMorePhotos: Bool) {
        self.bottomConstraint?.constant = loadingMorePhotos ? -20 : 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupNavigationItem() {
        self.navigationItem.title = "Unsplash Photos"
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = Dimensions.photosItemSize
        let numberOfCellsInRow = floor(Dimensions.screenWidth / Dimensions.photosItemSize.width)
        let inset = (Dimensions.screenWidth - (numberOfCellsInRow * Dimensions.photosItemSize.width)) / (numberOfCellsInRow + 1)
        layout.sectionInset = .init(top: inset, left: inset, bottom: inset, right: inset)
        return layout
    }
}
