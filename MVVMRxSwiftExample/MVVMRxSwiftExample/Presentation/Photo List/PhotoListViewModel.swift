//
//  PhotoListViewModel.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 28.05.2021.
//

import RxSwift
import RxCocoa

protocol PhotoListViewModel: class {
    var viewDidLoad: PublishRelay<Void> { get }
    var didChoosePhotoWithId: PublishRelay<String> { get }
    var willDisplayCellAtIndex: PublishRelay<Int> { get }
    var didEndDisplayingCellAtIndex: PublishRelay<Int> { get }
    var didScrollToTheBottom: PublishRelay<Void> { get }
    
    var isLoadingFirstPage: BehaviorRelay<Bool> { get }
    var isLoadingAdditionalPhotos: BehaviorRelay<Bool> { get }
    var unsplashPhotos: BehaviorRelay<[UnsplashPhoto]> { get }
    var imageRetrievedSuccess: PublishRelay<(UIImage, Int)> { get }
    var imageRetrievedError: PublishRelay<Int> { get }
}

final class PhotoListViewModelImpl: PhotoListViewModel {
    
    private let photoService: UnsplashAPIService
    private let photoLoadingService: DataLoadingService
    private let dataToImageService: DataToImageConversionService
    private let coordinator: PhotoListCoordinator
    
    private let disposeBag = DisposeBag()
    private let pageNumber = BehaviorRelay<Int>(value: 1)
    lazy var pageNumberObs = pageNumber.asObservable()
    
    let viewDidLoad = PublishRelay<Void>()
    let didChoosePhotoWithId = PublishRelay<String>()
    let willDisplayCellAtIndex = PublishRelay<Int>()
    let didEndDisplayingCellAtIndex = PublishRelay<Int>()
    let didScrollToTheBottom = PublishRelay<Void>()
    
    let isLoadingFirstPage = BehaviorRelay<Bool>(value: false)
    let isLoadingAdditionalPhotos = BehaviorRelay<Bool>(value: false)
    let unsplashPhotos = BehaviorRelay<[UnsplashPhoto]>(value: [])
    let imageRetrievedSuccess = PublishRelay<(UIImage, Int)>()
    let imageRetrievedError = PublishRelay<Int>()
    
    init(
        photosService: UnsplashAPIService,
        photoLoadingService: DataLoadingService,
        dataToImageService: DataToImageConversionService,
        coordinator: PhotoListCoordinator
    ) {
        self.photoService = photosService
        self.photoLoadingService = photoLoadingService
        self.dataToImageService = dataToImageService
        self.coordinator = coordinator
        
        bindOnViewDidLoad()
        bindOnWillDisplayCell()
        bindOnDidEndDisplayingCell()
        bindOnDidScrollToBottom()
        bindPageNumber()
        
        bindOnDidChoosePhoto()
    }
    
    private func bindOnViewDidLoad() {
        viewDidLoad
            .observeOn(MainScheduler.instance)
            .do(onNext: { [unowned self] _ in
                self.getPhotos()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindOnWillDisplayCell() {
        willDisplayCellAtIndex
            .filter({ [unowned self] index in
                self.unsplashPhotos.value.indices.contains(index)
            })
            .map { [unowned self] index in
                (index, self.unsplashPhotos.value[index])
            }
            .compactMap({ [weak self] (index, photo) in
                guard let urlString = photo.urls?.regular else {
                    //TODO: ask here
                    DispatchQueue.main.async {
                        self?.imageRetrievedError.accept(index)
                    }
                    return nil
                }
                return (index, urlString)
            })
            .flatMap({ [unowned self] (index, urlString) in
                self.photoLoadingService
                    .loadData(at: index, for: urlString)
                    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .concatMap { (data, error) in
                        Observable.of((index, data, error))
                    }
            }).subscribe(onNext: { [weak self] (index, data, error) in
                guard let self = self else { return }
                
                guard let imageData = data, let image = self.dataToImageService.getImage(from: imageData) else {
                    self.imageRetrievedError.accept(index)
                    return
                }
                
                self.imageRetrievedSuccess.accept((image, index))
            }).disposed(by: disposeBag)
    }
    
    private func bindOnDidEndDisplayingCell() {
        didEndDisplayingCellAtIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.photoLoadingService.stopLoading(at: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnDidScrollToBottom() {
        didScrollToTheBottom
            .flatMap({ [unowned self] _ -> Observable<Int> in
                let newPageNumber = self.pageNumber.value + 1
                return Observable.just(newPageNumber)
            })
            .bind(to: pageNumber)
            .disposed(by: disposeBag)
    }
    
    private func bindPageNumber() {
        pageNumber
            .subscribe(onNext: { [weak self] _ in
                self?.getPhotos()
            }).disposed(by: disposeBag)
    }
    
    private func bindOnDidChoosePhoto() {
        didChoosePhotoWithId
            .subscribe(onNext: { [unowned self] (id) in
                self.coordinator.pushToDetail(with: id)
            })
            .disposed(by: disposeBag)
    }
    
    private func getPhotos() {
        if pageNumber.value == 1 {
            isLoadingFirstPage.accept(true)
        } else {
            isLoadingAdditionalPhotos.accept(true)
        }
        
        photoService.getPhotos(pageNumber: pageNumber.value, perPage: 30)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                if self.pageNumber.value == 1 {
                    self.isLoadingFirstPage.accept(false)
                } else {
                    self.isLoadingAdditionalPhotos.accept(false)
                }
            })
            .filter({ (photos: [UnsplashPhoto]?, error: Error?) -> Bool in
                photos != nil && error == nil
            })
            .map({ (photos: [UnsplashPhoto]?, error: Error?) in
                return photos!
            })
            .flatMap({ [unowned self] (unsplashPhotos) -> Observable<[UnsplashPhoto]> in
                var photos: [UnsplashPhoto] = []
                let existingPhotos = self.unsplashPhotos.value
                if !existingPhotos.isEmpty {
                    photos.append(contentsOf: existingPhotos)
                }
                photos.append(contentsOf: unsplashPhotos)
                return Observable.just(photos)
            })
            .bind(to: unsplashPhotos)
            .disposed(by: disposeBag)
    }
}
