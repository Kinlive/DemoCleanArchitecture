//
//  SearchUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import Moya

protocol SearchRemoteUseCaseProtocol {
  associatedtype RequestValueT
  associatedtype ResponseValueT
  func search(query: RequestValueT, completionHandler: (ResponseValueT)) -> Cancellable

}

final class DefaultSearchRemoteUseCase: SearchRemoteUseCaseProtocol {

  typealias RequestValueT = PhotosQuery

  typealias ResponseValueT = (Photos?, Error?) -> Void

  private let repository: SearchRepository

  init(repo: SearchRepository) {
    self.repository = repo
  }

  func search(query: PhotosQuery, completionHandler: (@escaping (Photos?, Error?) -> Void)) -> Cancellable {
    return repository.request(searchQuery: query, completionHandler: completionHandler)
  }

}
