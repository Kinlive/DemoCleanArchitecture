//
//  FavoriteCoordinator.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

protocol FavoriteCoordinatorDependencies {
  func makeFavoriteViewController(actions: FavoriteViewModelActions) -> FavoriteViewController

  // make next page's viewcontroller etc.
}

class FavoriteCoordinator: BaseCoordinator {

  weak var navigationController: UINavigationController?
  let dependencies: FavoriteCoordinatorDependencies

  init(navigationController: UINavigationController, dependencies: FavoriteCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies

  }

  override func start() {
    let actions = FavoriteViewModelActions()
    let vc = dependencies.makeFavoriteViewController(actions: actions)

    navigationController?.pushViewController(vc, animated: true)
  }


}
