//
//  SearchUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchRemoteUseCase {
  func search(query: PhotosQuery, completionHandler: @escaping (Photos?, Error?) -> Void)
  func rx_search(query: PhotosQuery) -> Observable<Photos>
}

final class DefaultSearchRemoteUseCase: SearchRemoteUseCase {

  private let repository: SearchRepository

  init(repo: SearchRepository) {
    self.repository = repo
  }

  func search(query: PhotosQuery, completionHandler: (@escaping (Photos?, Error?) -> Void)) {
    repository.request(searchQuery: query, completionHandler: completionHandler)
  }

  func rx_search(query: PhotosQuery) -> Observable<Photos> {
//    let subject = PublishSubject<Photos>()
//    repository.request(searchQuery: query) { (photos, error) in
//      if let err = error {
//        subject.onError(err)
//        return
//      }
//      guard let photos = photos else {
//        subject.onError(error!)
//        return
//      }
//      subject.onNext(photos)
//      subject.onCompleted()
//    }
//
//    return subject

    return Observable.create { [weak self] observer -> Disposable in
      self?.repository.request(searchQuery: query, completionHandler: { (photos, error) in
        if let err = error {
          observer.onError(err)
          return
        }
        guard let photos = photos else {
          observer.onError(error!)
          return
        }
        observer.onNext(photos)
        observer.onCompleted()
      })

      return Disposables.create()
    }
  }

}
