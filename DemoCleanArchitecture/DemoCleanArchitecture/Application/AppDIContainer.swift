//
//  AppDIContainer.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

protocol AppDIContainerMakeScenes {
  func makeTabBarContainer() -> TabBarDIContainer
}

class AppDIContainer: AppDIContainerMakeScenes {

  // lazy var networkService
  // lazy storageService

  func makeTabBarContainer() -> TabBarDIContainer {
    return TabBarDIContainer() // <-- dependencies injection
  }
}
