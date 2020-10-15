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

  func save(favorite photoDTO: SearchResponseDTO.PhotosDTO.PhotoDTO) {
    dependencies.favoritesPhotosStorage.save(response: photoDTO)
  }

  func fetchAllFavorites(completion: @escaping (Result<[Photo], CoreDataStorageError>) -> Void) {
    dependencies.favoritesPhotosStorage.fetchAllFavorite(completion: completion)
  }
}
