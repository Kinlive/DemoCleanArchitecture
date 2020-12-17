//
//  SearchDIContainer.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

protocol SearchDIContainerMakeFactory {
  /// coordinator maker
  func makeSearchCoordinator(at navigationController: UINavigationController) -> SearchCoordinator

  /// SearchRepository maker
  func makeSearchRepository() -> SearchRepository

  /// SearchViewModel use cases maker
  func makeSearchViewModelUseCases() -> UseCases

  /// SearchViewModel maker
  func makeSearchViewModel(with action: SearchViewModelActions) -> SearchViewModel
}

final class SearchDIContainer: SearchDIContainerMakeFactory {
  // Define which depencies needed.
  typealias Dependencies = AppDependency

  private let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  // MARK: - Factory makes
  func makeSearchCoordinator(at navigationController: UINavigationController) -> SearchCoordinator {
    return SearchCoordinator(navigationController: navigationController, dependencies: self)
  }

  func makeSearchRepository() -> SearchRepository {
    return DefaultSearchRepository(dependencies: dependencies)
  }

  func makeSearchViewModelUseCases() -> UseCases {
    return UseCases(searchRemoteUseCase: DefaultSearchRemoteUseCase(repo: makeSearchRepository()),
                    searchLocalUseCase: DefaultSearchLocalUseCase(repo: makeSearchRepository()),
                    searchRecordUseCase: DefaultSearchRecordUseCase(repo: makeSearchRepository()))
  }

  func makeSearchViewModel(with action: SearchViewModelActions) -> SearchViewModel {
    return DefaultSearchViewModel(actions: action,
                                  useCases: makeSearchViewModelUseCases())
  }
}

// MARK: - Serach coordinator dependencies protocol methods
extension SearchDIContainer: SearchCoordinatorDependencies {
  func makeResultDIContainer(passValues: AppPassValues) -> ResultDIContainer {
    return ResultDIContainer(dependencies: dependencies, passValues: passValues)
  }

  func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController {
    return SearchViewController.create(with: makeSearchViewModel(with: actions))
  }

}
