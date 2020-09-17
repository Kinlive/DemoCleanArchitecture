//
//  TabBarDIContainer.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol TabBarDIContainerMakeScenesContainer {
  func makeSearchContainer() -> SearchDIContainer
  func makeFavoriteContainer() -> FavoriteDIContainer
}

class TabBarDIContainer: TabBarDIContainerMakeScenesContainer {

  init() {
    // dependencies
  }

  func makeSearchContainer() -> SearchDIContainer {
    return SearchDIContainer()
  }

  func makeFavoriteContainer() -> FavoriteDIContainer {
    return FavoriteDIContainer()
  }


}
