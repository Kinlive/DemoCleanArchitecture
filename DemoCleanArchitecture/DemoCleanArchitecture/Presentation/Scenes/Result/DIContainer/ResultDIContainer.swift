//
//  ResultDIContainer.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

protocol ResultDIContainerMakeFactory {
  func makeResultCoordinator(at navigationController: UINavigationController?) -> ResultCoordinator
  func makeResultUseCase() -> UseCases
  func makeFavoriteRepository() -> FavoriteRepository
}

final class ResultDIContainer: ResultDIContainerMakeFactory {

  typealias Dependencies = HasFavoritesPhotosStorage

  private let dependencies: Dependencies
  private let passValues: AppPassValues

  init(dependencies: Dependencies, passValues: AppPassValues) {
    self.dependencies = dependencies
    self.passValues = passValues
  }

  // MARK: - Factory makes
  func makeResultCoordinator(at navigationController: UINavigationController?) -> ResultCoordinator {
    return ResultCoordinator(navigationController: navigationController, dependencies: self)
  }

  func makeResultUseCase() -> UseCases {
    let showResultUseCase = DefaultShowResultUseCase(passValues: passValues)
    let saveFavoriteUseCase = DefaultSaveFavoriteUseCase(repo: makeFavoriteRepository())
    let fetchFavoriteUseCase = DefaultFetchFavoriteUseCase(repo: makeFavoriteRepository())
    
    return UseCases(showResultUseCase: showResultUseCase,
                    saveFavoriteUseCase: saveFavoriteUseCase,
                    fetchFavoriteUseCase: fetchFavoriteUseCase)
  }

  func makeFavoriteRepository() -> FavoriteRepository {
    return FavoriteRepository(dependencies: dependencies)
  }
}

extension ResultDIContainer: ResultCoordinatorDependencies {
  func makeResultViewController(actions: ResultViewModelActions) -> ResultViewController {
    let viewModel = DefaultResultViewModel(useCase: makeResultUseCase(), actions: actions)
    let resultVC = ResultViewController.create(with: viewModel)

    return resultVC
  }

  func backToSearchViewController() {

  }

}

