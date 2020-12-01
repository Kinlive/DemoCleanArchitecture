//
//  FavoriteCoordinator.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol FavoriteCoordinatorDependencies {
  func makeFavoriteViewController(actions: FavoriteViewModelActions) -> FavoriteViewController

  // make next page's viewcontroller etc.
}

class FavoriteCoordinator: BaseCoordinator {
  private let bag = DisposeBag()

  weak var navigationController: UINavigationController?
  let dependencies: FavoriteCoordinatorDependencies

  init(navigationController: UINavigationController, dependencies: FavoriteCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies

  }

  override func start() -> Completable {
    let subject = PublishSubject<Void>()

    let actions = FavoriteViewModelActions()
    let vc = dependencies.makeFavoriteViewController(actions: actions)
    vc.navigationItem.title = "Favorite photos"
    navigationController?.pushViewController(vc, animated: true)

    navigationController?.rx.delegate.sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
      .map { _ in }
      .bind(to: subject)
      .disposed(by: bag)
    
    return subject.ignoreElements()
  }


}
