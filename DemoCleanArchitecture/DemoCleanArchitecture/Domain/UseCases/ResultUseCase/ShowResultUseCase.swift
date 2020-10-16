//
//  ShowResultUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol ShowResultUseCase {
  func fetchResult() -> AppPassValues
}

final class DefaultShowResultUseCase: ShowResultUseCase {

  private let passValues: AppPassValues

  init(passValues: AppPassValues) {
    self.passValues = passValues
  }

  func fetchResult() -> AppPassValues {
    return passValues
  }
}
