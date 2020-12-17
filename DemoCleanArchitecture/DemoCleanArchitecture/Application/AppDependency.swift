//
//  AppDependency.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/22.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol HasSearchRemoteService {
  var searchService: SearchService? { get }
}

protocol HasCoreDataService {
  var photosStorage: PhotosStorage { get }
}

protocol HasFavoritesPhotosStorage {
  var favoritesPhotosStorage: FavoritesPhotosStorage { get }
}

protocol HasQuerysStorage {
  var querysStorage: QuerysStorage { get }
}

protocol HasSQLService {

}

protocol HasCachedService {
  var cacheManager: CacheManager { get }
}

// MARK: - Handle all services by AppDependency.
struct AppDependency: HasSearchRemoteService, HasCoreDataService, HasSQLService, HasCachedService, HasFavoritesPhotosStorage, HasQuerysStorage {

  /// HasSearchRemoteService dependency.
  var searchService: SearchService?

  /// HasCorDataService dependency.
  var photosStorage: PhotosStorage

  /// HasCachedService dependency.
  let cacheManager: CacheManager

  /// HasFavoritesPhotosStorage dependency.
  let favoritesPhotosStorage: FavoritesPhotosStorage

  /// HasQuerysStorage dependency
  let querysStorage: QuerysStorage


  init(remoteService: SearchService? = nil) {
    searchService = remoteService

    photosStorage = CoreDataPhotosStorage()

    cacheManager = CacheManager.shared

    favoritesPhotosStorage = CoreDataFavoritesPhotosStorage()

    querysStorage = CoreDataQuerysStorage()
  }

}
