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
            completion: @escaping (Error?) -> Void) {

    dependencies.favoritesPhotosStorage.save(response: photo.toDTO(), of: request.toDTO(), completion: completion)
  }

  func fetchAllFavorites(completion: @escaping (Result<[String : [Photo]], Error>) -> Void) {
    dependencies.favoritesPhotosStorage.fetchAllFavorite { result in
      switch result {
      case .success(let dicDTO):
        let transferToDomain: [String : [Photo]] = dicDTO.mapValues { $0.map { $0.toDomain() } }
        completion(.success(transferToDomain))

      case .failure(let error): completion(.failure(error))
      }
    }
  }

  func removeFavorite(photo: Photo,
                      completion: @escaping (Error?) -> Void) {

    dependencies.favoritesPhotosStorage.remove(response: photo.toDTO(), completion: completion)
  }
}
