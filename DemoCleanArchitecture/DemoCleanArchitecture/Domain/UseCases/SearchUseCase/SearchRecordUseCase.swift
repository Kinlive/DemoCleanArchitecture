//
//  SearchRecordUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/19.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchRecordUseCase {
  func getSearchRecord(completion: @escaping ([PhotosQuery], Error?) -> Void)
  func rx_searchRecord() -> Observable<[PhotosQuery]>
}

final class DefaultSearchRecordUseCase: SearchRecordUseCase {

  private let repository: SearchRepository

  init(repo: SearchRepository) {
    repository = repo
  }

  func getSearchRecord(completion: @escaping ([PhotosQuery], Error?) -> Void) {
    repository.recordQuerys(completionHandler: completion)
  }

  func rx_searchRecord() -> Observable<[PhotosQuery]> {
    return Observable.create { [weak self] observer -> Disposable in
      self?.repository.recordQuerys { (photoQuerys, error) in
        if let error = error {
          observer.onError(error)
          return
        }
        observer.onNext(photoQuerys)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
}
