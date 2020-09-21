//
//  SearchUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

class SearchUseCase: UseCase {
  typealias ImplementedRepository = SearchRepository

  var repository: SearchRepository

  required init(repo: SearchRepository) {
    self.repository = repo

  }

}
