//
//  AppDependency.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/22.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol HasSearchRemoteService {
  var searchService: SearchService { get }
}

protocol HasCoreDataService {
  var photosStorage: PhotosStorage { get }
}

protocol HasSQLService {

}

protocol HasCachedService {
  var cacheManager: CacheManager { get }
}

// MARK: - Handle all services by AppDependency.
struct AppDependency: HasSearchRemoteService, HasCoreDataService, HasSQLService, HasCachedService {

  /// HasSearchRemoteService dependencies.
  var searchService: SearchService

  /// HasCorDataService dependencies.
  var photosStorage: PhotosStorage

  let cacheManager: CacheManager


  init(remoteService: SearchService) {
    searchService = remoteService

    photosStorage = CoreDataPhotosStorage()

    cacheManager = CacheManager.shared
  }

}
