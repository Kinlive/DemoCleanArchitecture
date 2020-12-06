//
//  RemoveFavoriteUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/23.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import RxSwift

protocol RemoveFavoriteUseCase {
  func remove(favorite photo: Photo, completion: @escaping (Error?) -> Void)
  func rx_remove(favorite photo: Photo) -> Observable<Void>
}

final class DefaultRemoveFavoriteUseCase: RemoveFavoriteUseCase {
  private let repository: FavoriteRepository

  init(repo: FavoriteRepository) {
    self.repository = repo
  }

  func remove(favorite photo: Photo,
              completion: @escaping (Error?) -> Void) {

    repository.removeFavorite(photo: photo, completion: completion)
  }

  func rx_remove(favorite photo: Photo) -> Observable<Void> {
    // 不會通知到訂閱的對象 
//    return Completable.create { [weak self] (completable) -> Disposable in
//      self?.repository.removeFavorite(photo: photo, completion: { error in
//        if let error = error {
//          completable(.error(error))
//          return
//        }
//        completable(.completed)
//      })
//      return Disposables.create()
//    }

    return Observable.create { [weak self] observer -> Disposable in
      self?.repository.removeFavorite(photo: photo, completion: { error in
        if let error = error {
          observer.onError(error)
          return
        }
        observer.onNext(())
        observer.onCompleted()
      })

      return Disposables.create()
    }
  }
  
}
