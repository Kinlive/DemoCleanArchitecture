//
//  SearchUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import Moya

protocol SearchRemoteUseCaseProtocol {
  associatedtype RequestValueT
  associatedtype ResponseValueT
  func search(requestValue: RequestValueT, completionHandler: (ResponseValueT)) -> Cancellable

}

class DefaultSearchRemoteUseCase: SearchRemoteUseCaseProtocol {

  typealias RequestValueT = String

  typealias ResponseValueT = (Photos?, Error?) -> Void

  let repository: SearchRepository

  init(repo: SearchRepository) {
    self.repository = repo
  }

  func search(requestValue: String, completionHandler: (@escaping (Photos?, Error?) -> Void)) -> Cancellable {
    return repository.request(search: requestValue, completionHandler: completionHandler)
  }

}
