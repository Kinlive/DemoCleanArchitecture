//
//  FetchFavoriteUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import RxSwift

protocol FetchFavoriteUseCase {
  func fetchFavorite(completion: @escaping (Result<[String : [Photo]], Error>) -> Void)
  func rx_fetchFavorite() -> Observable<[String : [Photo]]>
}

final class DefaultFetchFavoriteUseCase: FetchFavoriteUseCase {

  private let repository: FavoriteRepository

  init(repo: FavoriteRepository) {
    repository = repo
  }

  func fetchFavorite(completion: @escaping (Result<[String : [Photo]], Error>) -> Void) {
    repository.fetchAllFavorites(completion: completion)
  }

  func rx_fetchFavorite() -> Observable<[String : [Photo]]> {

//    let subject = PublishSubject<[String : [Photo]]>()
//
//    repository.fetchAllFavorites { result in
//      switch result {
//      case .success(let values):
//        subject.onNext(values)
//        subject.onCompleted()
//      case .failure(let error):
//        subject.onError(error)
//      }
//    }
//
//    return subject

    return Observable.create { [weak self] observer -> Disposable in
      self?.repository.fetchAllFavorites(completion: { result in
        switch result {
        case .success(let values):
          observer.onNext(values)
          observer.onCompleted()

        case .failure(let error):
          observer.onError(error)
        }
      })
      return Disposables.create()
    }
  }
}
