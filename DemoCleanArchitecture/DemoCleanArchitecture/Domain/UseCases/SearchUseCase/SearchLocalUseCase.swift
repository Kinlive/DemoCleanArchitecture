//
//  SearchLocalUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/7.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol SearchLocalUseCase {
  func search(query: PhotosQuery, completionHandler: @escaping (Photos?, Error?) -> Void)
}

final class DefaultSearchLocalUseCase: SearchLocalUseCase {

  private let repository: SearchRepository

  init(repo: SearchRepository) {
    self.repository = repo
  }

  func search(query: PhotosQuery, completionHandler: @escaping ((Photos?, Error?) -> Void)) {
    repository.storage(searchQuery: query, completionHandler: completionHandler)
  }

}
