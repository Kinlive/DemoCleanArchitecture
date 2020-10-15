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

  /// SearchViewModel use cases maker
  func makeSearchViewModelUseCases() -> UseCases

  /// SearchRepository maker
  func makeSearchRepository() -> SearchRepository
}

final class SearchDIContainer: SearchDIContainerMakeFactory {
  // Define which depencies needed.
  typealias Dependencies = HasSearchRemoteService & HasCoreDataService

  private let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  // MARK: - Factory makes
  func makeSearchCoordinator(at navigationController: UINavigationController) -> SearchCoordinator {
    return SearchCoordinator(navigationController: navigationController, dependencies: self)
  }

  func makeSearchViewModelUseCases() -> UseCases {
    return UseCases(searchRemoteUseCase: .init(repo: makeSearchRepository()),
                    searchLocalUseCase: .init(repo: makeSearchRepository()))
  }

  func makeSearchRepository() -> SearchRepository {
    return SearchRepository(dependencies: dependencies)
  }
}

// MARK: - Serach coordinator dependencies protocol methods
extension SearchDIContainer: SearchCoordinatorDependencies {
  func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController {
    let viewModel = DefaultSearchViewModel(actions: actions, useCases: makeSearchViewModelUseCases())

    return SearchViewController.create(with: viewModel)
  }

  func makeSearchResultViewController() -> ResultViewController {
    return ResultViewController.create(with: DefaultResultViewModel())
  }


}
