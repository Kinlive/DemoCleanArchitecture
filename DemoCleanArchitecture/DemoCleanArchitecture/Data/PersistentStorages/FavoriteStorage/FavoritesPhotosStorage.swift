//
//  FavoritesPhotosStorage.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol FavoritesPhotosStorage {
  func save(response: SearchResponseDTO.PhotosDTO.PhotoDTO)
  func fetchAllFavorite(completion: @escaping (Result<[Photo], CoreDataStorageError>) -> Void)
}
