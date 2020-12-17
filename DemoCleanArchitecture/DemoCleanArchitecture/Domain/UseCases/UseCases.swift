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

protocol HasSaveFavoriteUseCase {
  var saveFavoriteUseCase: SaveFavoriteUseCase? { get }
}
protocol HasRemoveFavoriteUseCase {
  var removeFavoriteUseCase: RemoveFavoriteUseCase? { get }
}
protocol HasFetchFavoriteUseCase {
  var fetchFavoriteUseCase: FetchFavoriteUseCase? { get }
}

protocol HasSearchRecordUseCase {
  var searchRecordUseCase: SearchRecordUseCase? { get }
}

protocol HasTestUseCase {
  var testString: String { get }
}

struct UseCases: HasPhotosRemoteSearchUseCase, HasPhotosLocalSearchUseCase, HasTestUseCase, HasSaveFavoriteUseCase, HasFetchFavoriteUseCase, HasSearchRecordUseCase, HasRemoveFavoriteUseCase {

  var saveFavoriteUseCase: SaveFavoriteUseCase?
  var fetchFavoriteUseCase: FetchFavoriteUseCase?
  var removeFavoriteUseCase: RemoveFavoriteUseCase?
  var searchRemoteUseCase: SearchRemoteUseCase?
  var searchLocalUseCase: SearchLocalUseCase?
  var searchRecordUseCase: SearchRecordUseCase?

  var testString: String

  init(searchRemoteUseCase: SearchRemoteUseCase? = nil,
       searchLocalUseCase: SearchLocalUseCase? = nil,
       saveFavoriteUseCase: SaveFavoriteUseCase? = nil,
       removeFavoriteUseCase: RemoveFavoriteUseCase? = nil,
       fetchFavoriteUseCase: FetchFavoriteUseCase? = nil,
       searchRecordUseCase: SearchRecordUseCase? = nil,
      test: String = "") {

    self.searchRemoteUseCase = searchRemoteUseCase
    self.searchLocalUseCase = searchLocalUseCase
    self.saveFavoriteUseCase = saveFavoriteUseCase
    self.fetchFavoriteUseCase = fetchFavoriteUseCase
    self.removeFavoriteUseCase = removeFavoriteUseCase
    self.searchRecordUseCase = searchRecordUseCase

    self.testString = test
  }
}
