//
//  SearchLocalUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/7.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol SearchLocalUseCaseProtocol {
  associatedtype RequestValueT
  associatedtype ResponseValueT
  func search(requestValue: RequestValueT, completionHandler: (ResponseValueT))
}

class DefaultSearchLocalUseCase: SearchLocalUseCaseProtocol {
  typealias RequestValueT = String

  typealias ResponseValueT = (Photos?, Error?) -> Void

  let repository: SearchRepository

  init(repo: SearchRepository) {
    self.repository = repo
  }

  func search(requestValue: String, completionHandler: @escaping ((Photos?, Error?) -> Void)) {
    repository.storage(search: requestValue, completionHandler: completionHandler)
  }

}
