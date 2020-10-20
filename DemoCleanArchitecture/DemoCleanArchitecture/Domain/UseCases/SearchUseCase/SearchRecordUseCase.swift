//
//  SearchRecordUseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/19.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol SearchRecordUseCase {
  func getSearchRecord(completion: @escaping ([PhotosQuery], Error?) -> Void)
}

final class DefaultSearchRecordUseCase: SearchRecordUseCase {

  private let repository: SearchRepository

  init(repo: SearchRepository) {
    repository = repo
  }

  func getSearchRecord(completion: @escaping ([PhotosQuery], Error?) -> Void) {
    repository.recordQuerys(completionHandler: completion)
  }

}
