//
//  TabBarCoordinator.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TabBarCoordinator: BaseCoordinator {

  private let bag = DisposeBag()

  private weak var tabBarController: UITabBarController?
  private let tabBarDIContainer: TabBarDIContainer

  private var searchCoordinator: SearchCoordinator!
  private var favoriteCoordinator: FavoriteCoordinator!

  init(rootViewController: UITabBarController?, tabBarDIContainer: TabBarDIContainer) {
    self.tabBarController = rootViewController
    self.tabBarDIContainer = tabBarDIContainer
  }

  override func start() -> Completable {

    // setup search
    let searchContainer = tabBarDIContainer.makeSearchContainer()
    let searchNavigation = UINavigationController()
    searchNavigation.tabBarItem = UITabBarItem(title: "Search", image:  nil, selectedImage: nil)
    searchCoordinator = searchContainer.makeSearchCoordinator(at: searchNavigation)
    coordinator(to: searchCoordinator)
      .subscribe()
      .disposed(by: bag)

    // setup favorite
    let favoriteContainer = tabBarDIContainer.makeFavoriteContainer()
    let favoriteNavigation = UINavigationController()
    favoriteNavigation.tabBarItem = UITabBarItem(title: "Favor", image: nil, selectedImage: nil)
    favoriteCoordinator = favoriteContainer.makeFavoriteCoordinator(navigationController: favoriteNavigation)
    coordinator(to: favoriteCoordinator)
      .subscribe()
      .disposed(by: bag)

    // setup tabbar
    tabBarController?.viewControllers = [searchNavigation, favoriteNavigation]
    tabBarController?.delegate = self
    tabBarController?.selectedViewController = searchNavigation

    return .never()
  }
}

// MARK: - UITabBarController delegate
extension TabBarCoordinator: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    print("\(#function) didSelect \(viewController)")
  }
}
