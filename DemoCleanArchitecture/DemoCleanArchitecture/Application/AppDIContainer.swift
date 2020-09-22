//
//  AppDIContainer.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit
import Moya

protocol AppDIContainerMakeScenes {
  func makeTabBarContainer() -> TabBarDIContainer
}

class AppDIContainer: AppDIContainerMakeScenes {

  // lazy var networkService
  // lazy storageService

  func makeTabBarContainer() -> TabBarDIContainer {
    // Why initialized remote service here because I wanted to
    //  import frameworks Moya but not put it in the AppDependency.
    let remoteService = SearchService(provider: MoyaProvider<FlickrAPIType>(plugins: [NetworkLoggerPlugin()]))
    let appDependency = AppDependency(remoteService: remoteService)

    return TabBarDIContainer(dependencies: appDependency) // <-- dependencies injection
  }

}
