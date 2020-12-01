//
//  AppFlowCoordinator.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AppFlowCoordinator: BaseCoordinator {

  private let bag = DisposeBag()

  let appDIContainer: AppDIContainer
  weak var tabBarController: UITabBarController?

  init(tabBarController: UITabBarController, appDIContainer: AppDIContainer) {
    self.tabBarController = tabBarController
    self.appDIContainer = appDIContainer
  }

  override func start() -> Completable {

    let tabBarContainer = appDIContainer.makeTabBarContainer()
    let tabBarCoordinator = TabBarCoordinator(rootViewController: tabBarController, tabBarDIContainer: tabBarContainer)

    coordinator(to: tabBarCoordinator)
      .subscribe()
      .disposed(by: bag)

    return .never()
  }
}

