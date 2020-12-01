//
//  SearchCoordinator.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit
import Action
import RxSwift

protocol SearchCoordinatorDependencies {
  func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController
  func makeResultDIContainer(passValues: AppPassValues) -> ResultDIContainer
}

class SearchCoordinator: BaseCoordinator {
  private let bag = DisposeBag()

  weak var navigationController: UINavigationController?

  let dependencies: SearchCoordinatorDependencies

  private lazy var showResult: Action<PhotosQuery, Void> = { this in
    Action { query in
      let resultDIContainer = this.dependencies.makeResultDIContainer(passValues: AppPassValues(resultQuery: query))
      let resultCoordinator = resultDIContainer.makeResultCoordinator(at: this.navigationController)
      //resultCoordinator.start()

      return this.coordinator(to: resultCoordinator)
        .asObservable()
        .map { _ in } //Observable.empty()
    }
  }(self)

  init(navigationController: UINavigationController, dependencies: SearchCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }


  override func start() -> Completable {
    let subject = PublishSubject<Void>()

    // set navigation delegate
    navigationController?.delegate = self
    navigationController?.rx.delegate
      .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
      .map { _ in }
      .bind(to: subject)
      .disposed(by: bag)

    // Action make on coordinator
    let searchActions = SearchViewModelActions(
      showResult: showResult
    )

    let searchVC = dependencies.makeSearchViewController(actions: searchActions)
    searchVC.navigationItem.title = "Search photos"

    navigationController?.pushViewController(searchVC, animated: true)

    return subject.ignoreElements()
  }
}

extension SearchCoordinator: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    
    print("\(#function) will show : \(viewController)")
  }
}
