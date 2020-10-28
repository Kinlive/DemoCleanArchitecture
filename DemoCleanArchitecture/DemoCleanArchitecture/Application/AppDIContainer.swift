//
//  AppDIContainer.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit
import Moya

protocol AppDIContainerMakeFactory {
  func makeTabBarContainer() -> TabBarDIContainer
}

class AppDIContainer: AppDIContainerMakeFactory {

  func makeTabBarContainer() -> TabBarDIContainer {

    let remoteService = SearchService(provider: MoyaProvider<FlickrAPIType>(plugins: [NetworkLoggerPlugin()]))

    let appDependency = AppDependency(remoteService: remoteService)

    return TabBarDIContainer(dependencies: appDependency) // <-- dependencies injection
  }

}
