//
//  FavoriteDIContainer.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

protocol FavoriteDIContainerMakeFactory {
  func makeFavoriteCoordinator(navigationController: UINavigationController) -> FavoriteCoordinator
  func makeFavoriteViewModelUseCases() -> UseCases
  func makeFavoriteRepository() -> FavoriteRepository
}

class FavoriteDIContainer: FavoriteDIContainerMakeFactory {

  typealias Dependencies = HasFavoritesPhotosStorage

  private let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  // MARK: - Make factory methods
  func makeFavoriteCoordinator(navigationController: UINavigationController) -> FavoriteCoordinator {
    return FavoriteCoordinator(navigationController: navigationController, dependencies: self)
  }

  func makeFavoriteViewModelUseCases() -> UseCases {
    return UseCases(removeFavoriteUseCase: DefaultRemoveFavoriteUseCase(repo: makeFavoriteRepository()),
                    fetchFavoriteUseCase: DefaultFetchFavoriteUseCase(repo: makeFavoriteRepository())
    )
  }

  func makeFavoriteRepository() -> FavoriteRepository {
    return DefaultFavoriteRepository(dependencies: dependencies)
  }

}

extension FavoriteDIContainer: FavoriteCoordinatorDependencies {
  func makeFavoriteViewController(actions: FavoriteViewModelActions) -> FavoriteViewController {
    let viewModel = DefaultFavoriteViewModel(actions: actions, useCases: makeFavoriteViewModelUseCases())

    return FavoriteViewController.create(with: viewModel)
  }

}
