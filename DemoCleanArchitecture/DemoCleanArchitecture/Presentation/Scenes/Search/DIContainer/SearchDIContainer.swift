//
//  SearchDIContainer.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

class SearchDIContainer {

  typealias Dependencies = HasSearchRemoteService & HasCoreDataService
  // let service:
  private let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  func makeSearchCoordinator(navigationController: UINavigationController) -> SearchCoordinator {
    return SearchCoordinator(navigationController: navigationController, dependencies: self)
  }

  func makeSearchViewModelActions() -> SearchViewModelActions {
    return SearchViewModelActions()
  }
}

extension SearchDIContainer: SearchCoordinatorDependencies {
  func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController {
    let viewModel = DefaultSearchViewModel(testTitle: "I test display now!!")

    return SearchViewController.create(with: viewModel)
  }

  func makeSearchResultViewController() -> ResultViewController {
    return ResultViewController.create(with: DefaultResultViewModel())
  }


}
