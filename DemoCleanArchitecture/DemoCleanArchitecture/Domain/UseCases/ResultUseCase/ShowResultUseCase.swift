//
//  ShowResultUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol ShowResultUseCase {
  typealias PassValues = HasResultValues
  func fetchResult() -> PassValues
}

final class DefaultShowResultUseCase: ShowResultUseCase {
  private let passValues: PassValues

  init(passValues: AppPassValues) {
    self.passValues = passValues
  }

  func fetchResult() -> PassValues {
    return passValues
  }
}
