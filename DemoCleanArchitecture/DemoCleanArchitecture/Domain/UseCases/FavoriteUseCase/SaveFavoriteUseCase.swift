//
//  SaveFavoriteUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol SaveFavoriteUseCase {
  func save(favorite photoDTO: SearchResponseDTO.PhotosDTO.PhotoDTO,
            completion: @escaping (CoreDataStorageError?) -> Void)
}

final class DefaultSaveFavoriteUseCase: SaveFavoriteUseCase {

  private let repository: FavoriteRepository

  init(repo: FavoriteRepository) {
    repository = repo
  }

  func save(favorite photoDTO: SearchResponseDTO.PhotosDTO.PhotoDTO,
            completion: @escaping (CoreDataStorageError?) -> Void) {
    
    repository.save(favorite: photoDTO, completion: completion)
  }

}
