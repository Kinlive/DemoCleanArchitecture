//
//  ResultCoordinator.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

protocol ResultCoordinatorDependencies {
  func makeResultViewController(actions: ResultViewModelActions) -> ResultViewController
  func backToSearchViewController()
}

class ResultCoordinator: BaseCoordinator {

  private weak var navigationController: UINavigationController?
  private let dependencies: ResultCoordinatorDependencies

  init(
    navigationController: UINavigationController?,
    dependencies: ResultCoordinatorDependencies) {

    self.navigationController = navigationController
    self.dependencies = dependencies
  }

  override func start() {
    let resultVC = dependencies.makeResultViewController(actions: ResultViewModelActions())
    navigationController?.pushViewController(resultVC, animated: true)
  }
}
