//
//  ResultCoordinator.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ResultCoordinatorDependencies {
  func makeResultViewController(actions: ResultViewModelActions) -> ResultViewController
  func backToSearchViewController()
}

class ResultCoordinator: BaseCoordinator {

  private let bag = DisposeBag()

  private weak var navigationController: UINavigationController?
  private let dependencies: ResultCoordinatorDependencies

  init(
    navigationController: UINavigationController?,
    dependencies: ResultCoordinatorDependencies) {

    self.navigationController = navigationController
    self.dependencies = dependencies
  }

  override func start() -> Completable {
    let subject = PublishSubject<Void>()

    // set navigation delelgate
    navigationController?.delegate = self
    navigationController?.rx.delegate
      .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
      .map { _ in }
      .bind(to: subject)
      .disposed(by: bag)

    let resultVC = dependencies.makeResultViewController(actions: ResultViewModelActions())
    resultVC.navigationItem.title = "Result"

    navigationController?.pushViewController(resultVC, animated: true)

    return subject
      .take(1)
      .ignoreElements()
  }
}

extension ResultCoordinator: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    print("\(#function) will show : \(viewController)")
  }
}
