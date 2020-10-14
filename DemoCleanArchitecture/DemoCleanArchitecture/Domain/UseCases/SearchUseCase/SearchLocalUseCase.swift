//
//  SearchLocalUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/7.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol SearchLocalUseCaseProtocol {
  associatedtype RequestValueT
  associatedtype ResponseValueT
  func search(query: RequestValueT, completionHandler: (ResponseValueT))
}

final class DefaultSearchLocalUseCase: SearchLocalUseCaseProtocol {
  typealias RequestValueT = PhotosQuery

  typealias ResponseValueT = (Photos?, Error?) -> Void

  private let repository: SearchRepository

  init(repo: SearchRepository) {
    self.repository = repo
  }

  func search(query: PhotosQuery, completionHandler: @escaping ((Photos?, Error?) -> Void)) {
    repository.storage(searchQuery: query, completionHandler: completionHandler)
  }

}
