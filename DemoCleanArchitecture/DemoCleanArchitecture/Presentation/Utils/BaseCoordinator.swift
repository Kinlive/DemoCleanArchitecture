//
//  Coordinator.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import RxSwift

class BaseCoordinator: NSObject {

  private var childCoordinators: [UUID : BaseCoordinator] = [:]
  private let identifier = UUID()

  func start() -> Completable {
    fatalError("\(#function) method should be implemented.")
  }

  private func store(coordinator: BaseCoordinator) {
    childCoordinators[coordinator.identifier] = coordinator
  }

  func free(coordinator: BaseCoordinator) {
    childCoordinators[coordinator.identifier] = nil
  }

  func coordinator(to coordinator: BaseCoordinator) -> Completable {
    store(coordinator: coordinator)

    return coordinator.start()
  }
}
