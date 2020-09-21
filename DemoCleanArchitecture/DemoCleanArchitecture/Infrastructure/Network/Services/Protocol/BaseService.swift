//
//  BaseService.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/21.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import Moya

protocol BaseService {

  associatedtype TargetTypeBase: TargetType
  associatedtype ReturnValueBase
  associatedtype CancellableBase

  var provider: MoyaProvider<TargetTypeBase> { get }
  init(provider: MoyaProvider<TargetTypeBase>)

  @discardableResult
  func request(targetType: TargetTypeBase, completion: @escaping (ReturnValueBase?) -> Void) -> CancellableBase
}

