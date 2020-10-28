//
//  SaveFavoriteUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol SaveFavoriteUseCase {
  func save(favorite photo: Photo,
            of request: PhotosQuery,
            completion: @escaping (CoreDataStorageError?) -> Void)
}

final class DefaultSaveFavoriteUseCase: SaveFavoriteUseCase {

  private let repository: FavoriteRepository

  init(repo: FavoriteRepository) {
    repository = repo
  }

  func save(favorite photo: Photo,
            of request: PhotosQuery,
            completion: @escaping (CoreDataStorageError?) -> Void) {

    repository.save(favorite: photo, of: request, completion: completion)
  }

}
