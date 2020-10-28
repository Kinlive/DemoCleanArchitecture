//
//  SearchUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol SearchRemoteUseCase {
  func search(query: PhotosQuery, completionHandler: @escaping (Photos?, Error?) -> Void)

}

final class DefaultSearchRemoteUseCase: SearchRemoteUseCase {

  private let repository: SearchRepository

  init(repo: SearchRepository) {
    self.repository = repo
  }

  func search(query: PhotosQuery, completionHandler: (@escaping (Photos?, Error?) -> Void)) {
    repository.request(searchQuery: query, completionHandler: completionHandler)
  }

}
