//
//  FavoriteRepository.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/28.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol FavoriteRepository {
  func save(favorite photo: Photo, of request: PhotosQuery, completion: @escaping (CoreDataStorageError?) -> Void)
  func fetchAllFavorites(completion: @escaping (Result<[String : [Photo]], CoreDataStorageError>) -> Void)
  func removeFavorite(photo: Photo, completion: @escaping (CoreDataStorageError?) -> Void)
}
