//
//  UnsplashAPIService.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 29.05.2021.
//

import RxSwift

protocol UnsplashAPIService: class {
    func getPhotos() -> Observable<([UnsplashPhoto]?, Error?)>
    func getPhotos(pageNumber: Int, perPage: Int) -> Observable<([UnsplashPhoto]?, Error?)>
    func getRandomPhotos(count: Int) -> Observable<([UnsplashPhoto]?, Error?)>
    func getPhoto(id: String) -> Observable<(UnsplashPhoto?, Error?)>
}

class UnsplashPhotosServiceImpl: UnsplashAPIService {
    private let networkClient = NetworkClient()
    
    func getPhotos() -> Observable<([UnsplashPhoto]?, Error?)> {
        self.networkClient.getArray([UnsplashPhoto].self,
                                    UnsplashEndpoints.getPhotos)
    }
    
    func getPhotos(pageNumber: Int, perPage: Int) -> Observable<([UnsplashPhoto]?, Error?)> {
        return Observable.deferred {
            let parameter = ["page": String(pageNumber),
                             "per_page": String(perPage),
                             "order_by": "popular"]
            return self.networkClient.getArray([UnsplashPhoto].self, UnsplashEndpoints.getPhotos, parameters: parameter)
        }
    }
    
    func getRandomPhotos(count: Int) -> Observable<([UnsplashPhoto]?, Error?)> {
        return Observable.deferred {
            let parameter = ["count": String(count)]
            return self.networkClient.getArray([UnsplashPhoto].self, UnsplashEndpoints.getRandomPhotos, parameters: parameter)
        }
    }
    
    func getPhoto(id: String) -> Observable<(UnsplashPhoto?, Error?)> {
        return Observable.deferred {
            return self.networkClient.get(UnsplashPhoto.self, "\(UnsplashEndpoints.getPhotoById)\(id)")
        }
    }
}
