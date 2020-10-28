//
//  RemoveFavoriteUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/23.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol RemoveFavoriteUseCase {
  func remove(favorite photo: Photo, completion: @escaping (CoreDataStorageError?) -> Void)
}

final class DefaultRemoveFavoriteUseCase: RemoveFavoriteUseCase {
  private let repository: FavoriteRepository

  init(repo: FavoriteRepository) {
    self.repository = repo
  }

  func remove(favorite photo: Photo,
              completion: @escaping (CoreDataStorageError?) -> Void) {

    repository.removeFavorite(photo: photo, completion: completion)
  }
  
}
