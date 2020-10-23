//
//  FavoriteRepository.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

final class FavoriteRepository {

  typealias Dependencies = HasFavoritesPhotosStorage

  private let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  func save(favorite photoDTO: SearchResponseDTO.PhotosDTO.PhotoDTO,
            completion: @escaping (CoreDataStorageError?) -> Void) {

    dependencies.favoritesPhotosStorage.save(response: photoDTO, completion: completion)
  }

  func fetchAllFavorites(completion: @escaping (Result<[Photo], CoreDataStorageError>) -> Void) {
    dependencies.favoritesPhotosStorage.fetchAllFavorite(completion: completion)
  }

  func removeFavorite(photoDTO: SearchResponseDTO.PhotosDTO.PhotoDTO,
                      completion: @escaping (CoreDataStorageError?) -> Void) {

    dependencies.favoritesPhotosStorage.remove(response: photoDTO, completion: completion)
  }
}
