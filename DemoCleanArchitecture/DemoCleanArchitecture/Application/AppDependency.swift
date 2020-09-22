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
  var demoService: String { get }
}

protocol HasSQLService {

}

protocol HasCachedService {

}

// MARK: - Handle all services by AppDependency.
struct AppDependency: HasSearchRemoteService, HasCoreDataService, HasSQLService, HasCachedService {

  // MARK: HasSearchRemoteService dependencies.
  var searchService: SearchService

  // MARK: HasCorDataService dependencies.
  var demoService: String


  init(remoteService: SearchService) {
    self.searchService = remoteService

    self.demoService = "You got a Service with core data."

  }

}
