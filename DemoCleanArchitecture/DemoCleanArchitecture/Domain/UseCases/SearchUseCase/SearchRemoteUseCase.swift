//
//  SearchUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import Moya

protocol SearchRemoteUseCase {
  func search(query: PhotosQuery, completionHandler: @escaping (Photos?, Error?) -> Void) -> Cancellable

}

final class DefaultSearchRemoteUseCase: SearchRemoteUseCase {

  private let repository: SearchRepository

  init(repo: SearchRepository) {
    self.repository = repo
  }

  func search(query: PhotosQuery, completionHandler: (@escaping (Photos?, Error?) -> Void)) -> Cancellable {
    return repository.request(searchQuery: query, completionHandler: completionHandler)
  }

}
