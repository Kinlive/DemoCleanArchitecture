//
//  FavoritesPhotosStorage.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol FavoritesPhotosStorage {
  func save(response: SearchResponseDTO.PhotosDTO.PhotoDTO, of request: SearchRequestDTO, completion: @escaping (CoreDataStorageError?) -> Void)
  func fetchAllFavorite(completion: @escaping (Result<[String : [SearchResponseDTO.PhotosDTO.PhotoDTO]], CoreDataStorageError>) -> Void)
  func remove(response: SearchResponseDTO.PhotosDTO.PhotoDTO, completion: @escaping (CoreDataStorageError?) -> Void)
}
