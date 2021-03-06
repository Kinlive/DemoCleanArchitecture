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
  func makeResultDIContainer(passValues: AppPassValues) -> ResultDIContainer
}

class SearchCoordinator: BaseCoordinator {

  weak var navigationController: UINavigationController?

  let dependencies: SearchCoordinatorDependencies


  init(navigationController: UINavigationController, dependencies: SearchCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }


  override func start() {

    // Action make on coordinator
    let searchActions = SearchViewModelActions(
      showResult: showResult
    )

    let searchVC = dependencies.makeSearchViewController(actions: searchActions)
    searchVC.navigationItem.title = "Search photos"
    navigationController?.pushViewController(searchVC, animated: true)

  }

  private func showResult(of query: PhotosQuery) {
    let resultDIContainer = dependencies.makeResultDIContainer(passValues: AppPassValues(resultQuery: query))
    let resultCoordinator = resultDIContainer.makeResultCoordinator(at: navigationController)
    resultCoordinator.start()
  }
}
