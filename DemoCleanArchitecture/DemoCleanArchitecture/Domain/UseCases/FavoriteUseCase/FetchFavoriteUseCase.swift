//
//  FetchFavoriteUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol FetchFavoriteUseCase {
  func fetchFavorite(completion: @escaping (Result<[String : [Photo]], Error>) -> Void)
}

final class DefaultFetchFavoriteUseCase: FetchFavoriteUseCase {

  private let repository: FavoriteRepository

  init(repo: FavoriteRepository) {
    repository = repo
  }

  func fetchFavorite(completion: @escaping (Result<[String : [Photo]], Error>) -> Void) {
    repository.fetchAllFavorites(completion: completion)
  }
}
