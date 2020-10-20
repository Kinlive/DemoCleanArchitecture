//
//  QuerysStorage.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/19.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol QuerysStorage {
  func getSearchRecord(completion: @escaping (Result<[SearchRequestDTO]?, CoreDataStorageError>) -> Void)
}
