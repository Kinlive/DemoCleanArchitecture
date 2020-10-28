//
//  TabBarDIContainer.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol TabBarDIContainerMakeFactory {
  func makeSearchContainer() -> SearchDIContainer
  func makeFavoriteContainer() -> FavoriteDIContainer
}

class TabBarDIContainer: TabBarDIContainerMakeFactory {

  typealias Dependencies = AppDependency

  private let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  func makeSearchContainer() -> SearchDIContainer {
    return SearchDIContainer(dependencies: dependencies)
  }

  func makeFavoriteContainer() -> FavoriteDIContainer {
    return FavoriteDIContainer(dependencies: dependencies)
  }


}
