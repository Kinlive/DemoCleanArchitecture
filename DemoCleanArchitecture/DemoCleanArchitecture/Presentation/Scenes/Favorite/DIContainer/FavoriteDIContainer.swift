//
//  FavoriteDIContainer.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

class FavoriteDIContainer {

  // service / usecase / dependencies

  func makeFavoriteCoordinator(navigationController: UINavigationController) -> FavoriteCoordinator {
    return FavoriteCoordinator(navigationController: navigationController, dependencies: self)
  }

}

extension FavoriteDIContainer: FavoriteCoordinatorDependencies {
  func makeFavoriteViewController(actions: FavoriteViewModelActions) -> FavoriteViewController {
    let viewModel = DefaultFavoriteViewModel(actions: actions, testTitle: "I get Favorite string")

    return FavoriteViewController.create(with: viewModel)
  }

}
