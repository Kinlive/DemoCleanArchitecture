//
//  TabBarCoordinator.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

class TabBarCoordinator: BaseCoordinator {

  private weak var tabBarController: UITabBarController?
  private let tabBarDIContainer: TabBarDIContainer

  private var searchCoordinator: SearchCoordinator?
  private var favoriteCoordinator: FavoriteCoordinator?

  init(rootViewController: UITabBarController?, tabBarDIContainer: TabBarDIContainer) {
    self.tabBarController = rootViewController
    self.tabBarDIContainer = tabBarDIContainer
  }

  override func start() {

    let searchContainer = tabBarDIContainer.makeSearchContainer()

    let searchNavigation = UINavigationController()
    searchNavigation.tabBarItem = UITabBarItem(title: "Search", image:  nil, selectedImage: nil)
    searchCoordinator = searchContainer.makeSearchCoordinator(at: searchNavigation)
    searchCoordinator?.start()

    let favoriteContainer = tabBarDIContainer.makeFavoriteContainer()
    let favoriteNavigation = UINavigationController()
    favoriteNavigation.tabBarItem = UITabBarItem(title: "Favor", image: nil, selectedImage: nil)
    favoriteCoordinator = favoriteContainer.makeFavoriteCoordinator(navigationController: favoriteNavigation)
    favoriteCoordinator?.start()

    tabBarController?.viewControllers = [searchNavigation, favoriteNavigation]
    tabBarController?.delegate = self
    tabBarController?.selectedViewController = searchNavigation

  }
}

// MARK: - UITabBarController delegate
extension TabBarCoordinator: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

  }
}
