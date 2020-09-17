//
//  SearchCoordinator.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

protocol SearchCoordinatorDependencies {
  func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController
  func makeSearchResultViewController() -> ResultViewController
}

class SearchCoordinator: BaseCoordinator {

  weak var navigationController: UINavigationController?

  let dependencies: SearchCoordinatorDependencies


  init(navigationController: UINavigationController, dependencies: SearchCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }


  override func start() {

    let searchActions = SearchViewModelActions()
    let searchVC = dependencies.makeSearchViewController(actions: searchActions)
    navigationController?.pushViewController(searchVC, animated: true)

    // let viewModel = SearchViewModel(useCase: searchDIContainer.makeUseCase(), actions: searchDIContainer.makeActions())
    // let vc = SearchViewController.create(with: ViewModel)
    // self.navigationController.pushViewController(vc, animated: true)
  }
}
