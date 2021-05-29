//
//  FetchService.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 29.05.2021.
//

import RxSwift

protocol DataLoadingService: class {
    func loadData(for urlString: String) -> Observable<(Data?, Error?)>
    func loadData(at index: Int, for urlString: String) -> Observable<(Data?, Error?)>
    func stopLoading(at index: Int)
}

class DataLoadingServiceImpl: DataLoadingService {
    
    private var tasks: [Int: Disposable] = [:]
    
    func loadData(for urlString: String) -> Observable<(Data?, Error?)> {
        return Observable.create { observer in
            
            guard let url = URL(string: urlString) else {
                observer.onNext((nil, NetworkError.invalidURL))
                return Disposables.create()
            }
            
            let task = NetworkClient.getData(url)
                .subscribe(onNext: { (data, error) in
                    guard let data = data, error == nil else {
                        observer.onNext((nil, error))
                        return
                    }
                    
                    observer.onNext((data, nil))
                })
            
            return Disposables.create {
                task.dispose()
            }
        }
    }
    
    func loadData(at index: Int, for urlString: String) -> Observable<(Data?, Error?)> {
        return Observable.create { [weak self] observer in
            guard let url = URL(string: urlString) else {
                observer.onNext((nil, NetworkError.invalidURL))
                return Disposables.create()
            }
            
            let task = NetworkClient.getData(url)
                .subscribe(onNext: { (data, error) in
                    guard let data = data, error == nil else {
                        observer.onNext((nil, error))
                        return
                    }
                    
                    observer.onNext((data, nil))
                })
            
            self?.tasks[index] = task
            
            return Disposables.create {
                task.dispose()
            }
        }
    }
    
    func stopLoading(at index: Int) {
        tasks[index]?.dispose()
    }
}
