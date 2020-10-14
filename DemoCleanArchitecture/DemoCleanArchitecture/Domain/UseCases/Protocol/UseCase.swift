//
//  UseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/18.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

// MARK: - Each use case executes a single business unit.
/* protocol UseCase {

  associatedtype ImplementedRepository
  var repository: ImplementedRepository { get }

  init(repo: ImplementedRepository)
}
*/

protocol HasPhotosRemoteSearchUseCase {
  var searchRemoteUseCase: DefaultSearchRemoteUseCase? { get }
}

protocol HasPhotosLocalSearchUseCase {
  var searchLocalUseCase: DefaultSearchLocalUseCase? { get }
}

protocol HasTestUseCase {
  var testString: String { get }
}

struct UseCases: HasPhotosRemoteSearchUseCase, HasPhotosLocalSearchUseCase, HasTestUseCase {

  var searchRemoteUseCase: DefaultSearchRemoteUseCase?
  var searchLocalUseCase: DefaultSearchLocalUseCase?
  var testString: String

  init(searchRemoteUseCase: DefaultSearchRemoteUseCase? = nil,
       searchLocalUseCase: DefaultSearchLocalUseCase? = nil, test: String = "") {
    self.searchRemoteUseCase = searchRemoteUseCase
    self.searchLocalUseCase = searchLocalUseCase
    self.testString = test
  }
}
