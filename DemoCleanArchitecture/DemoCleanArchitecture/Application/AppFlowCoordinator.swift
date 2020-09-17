//
//  AppFlowCoordinator.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit



class AppFlowCoordinator: BaseCoordinator {

  let appDIContainer: AppDIContainer
  weak var tabBarController: UITabBarController?
  // dependency


  init(tabBarController: UITabBarController, appDIContainer: AppDIContainer) {
    self.tabBarController = tabBarController
    self.appDIContainer = appDIContainer
  }

  override func start() {

    let tabBarContainer = appDIContainer.makeTabBarContainer()
    let tabBarCoordinator = TabBarCoordinator(rootViewController: tabBarController, tabBarDIContainer: tabBarContainer)

    tabBarCoordinator.start()
  }

  


}

