//
//  FavoriteRepository.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

final class DefaultFavoriteRepository: FavoriteRepository {

  typealias Dependencies = HasFavoritesPhotosStorage

  private let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  func save(favorite photo: Photo,
            of request: PhotosQuery,
            completion: @escaping (CoreDataStorageError?) -> Void) {

    dependencies.favoritesPhotosStorage.save(response: photo.toDTO(), of: request.toDTO(), completion: completion)
  }

  func fetchAllFavorites(completion: @escaping (Result<[String : [Photo]], CoreDataStorageError>) -> Void) {
    dependencies.favoritesPhotosStorage.fetchAllFavorite(completion: completion)
  }

  func removeFavorite(photo: Photo,
                      completion: @escaping (CoreDataStorageError?) -> Void) {

    dependencies.favoritesPhotosStorage.remove(response: photo.toDTO(), completion: completion)
  }
}
