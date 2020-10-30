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
  func makeSearchRepository() -> SearchRepository
}

final class ResultDIContainer: ResultDIContainerMakeFactory {

  typealias Dependencies = AppDependency

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
    return UseCases(searchRemoteUseCase: DefaultSearchRemoteUseCase(repo: makeSearchRepository()),
                    saveFavoriteUseCase: DefaultSaveFavoriteUseCase(repo: makeFavoriteRepository()),
                    removeFavoriteUseCase: DefaultRemoveFavoriteUseCase(repo: makeFavoriteRepository()),
                    fetchFavoriteUseCase: DefaultFetchFavoriteUseCase(repo: makeFavoriteRepository()))
  }

  func makeFavoriteRepository() -> FavoriteRepository {
    return DefaultFavoriteRepository(dependencies: dependencies)
  }

  func makeSearchRepository() -> SearchRepository {
    return DefaultSearchRepository(dependencies: dependencies)
  }
}

extension ResultDIContainer: ResultCoordinatorDependencies {
  func makeResultViewController(actions: ResultViewModelActions) -> ResultViewController {
    let viewModel = DefaultResultViewModel(useCase: makeResultUseCase(), actions: actions, passValues: passValues)
    let resultVC = ResultViewController.create(with: viewModel)

    return resultVC
  }

  func backToSearchViewController() {

  }

}

