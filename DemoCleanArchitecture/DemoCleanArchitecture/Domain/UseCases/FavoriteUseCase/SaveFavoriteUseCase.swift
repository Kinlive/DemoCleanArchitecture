//
//  SaveFavoriteUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import RxSwift

protocol SaveFavoriteUseCase {
  func save(favorite photo: Photo,
            of request: PhotosQuery,
            completion: @escaping (Error?) -> Void)
  func rx_save(favorite photo: Photo, of request: PhotosQuery) -> Observable<Void>
}

final class DefaultSaveFavoriteUseCase: SaveFavoriteUseCase {

  private let repository: FavoriteRepository

  init(repo: FavoriteRepository) {
    repository = repo
  }

  func save(favorite photo: Photo,
            of request: PhotosQuery,
            completion: @escaping (Error?) -> Void) {

    repository.save(favorite: photo, of: request, completion: completion)
  }

  func rx_save(favorite photo: Photo, of request: PhotosQuery) -> Observable<Void> {

    return Observable<Void>.create { [weak self] observer -> Disposable in
      self?.repository.save(favorite: photo, of: request) { error in
        if let error = error {
          observer.onError(error)
          return
        }
        observer.onNext(())
        observer.onCompleted()
      }
      return Disposables.create()
    }
//    .ignoreElements() // 要是回傳為 Completable 將不會通知訂閱對象。

//    let subject = PublishSubject<Void>()
//    repository.save(favorite: photo, of: request) { (error) in
//      if let error = error {
//          subject.onError(error)
//          return
//        }
//      subject.onNext(())
//      subject.onCompleted()
//      }
//
//    return subject//.ignoreElements()
  }

}
