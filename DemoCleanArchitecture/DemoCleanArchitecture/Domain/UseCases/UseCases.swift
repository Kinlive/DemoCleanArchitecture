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
  var searchRemoteUseCase: SearchRemoteUseCase? { get }
}

protocol HasPhotosLocalSearchUseCase {
  var searchLocalUseCase: SearchLocalUseCase? { get }
}

protocol HasShowResultUseCase {
  var showResultUseCase: ShowResultUseCase? { get }
}

protocol HasSaveFavoriteUseCase {
  var saveFavoriteUseCase: SaveFavoriteUseCase? { get }
}

protocol HasFetchFavoriteUseCase {
  var fetchFavoriteUseCase: FetchFavoriteUseCase? { get }
}

protocol HasTestUseCase {
  var testString: String { get }
}

struct UseCases: HasPhotosRemoteSearchUseCase, HasPhotosLocalSearchUseCase, HasTestUseCase,
  HasShowResultUseCase, HasSaveFavoriteUseCase, HasFetchFavoriteUseCase {

  var showResultUseCase: ShowResultUseCase?
  var saveFavoriteUseCase: SaveFavoriteUseCase?
  var fetchFavoriteUseCase: FetchFavoriteUseCase?
  var searchRemoteUseCase: SearchRemoteUseCase?
  var searchLocalUseCase: SearchLocalUseCase?
  var testString: String

  init(searchRemoteUseCase: DefaultSearchRemoteUseCase? = nil,
       searchLocalUseCase: DefaultSearchLocalUseCase? = nil,
       showResultUseCase: ShowResultUseCase? = nil,
       saveFavoriteUseCase: SaveFavoriteUseCase? = nil,
       fetchFavoriteUseCase: FetchFavoriteUseCase? = nil,
      test: String = "") {

    self.searchRemoteUseCase = searchRemoteUseCase
    self.searchLocalUseCase = searchLocalUseCase
    self.showResultUseCase = showResultUseCase
    self.saveFavoriteUseCase = saveFavoriteUseCase
    self.fetchFavoriteUseCase = fetchFavoriteUseCase

    self.testString = test
  }
}
