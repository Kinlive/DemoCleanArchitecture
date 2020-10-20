//
//  CoreDataQuerysStorage.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/19.
//  Copyright © 2020 KinWei. All rights reserved.
//

import CoreData

final class CoreDataQuerysStorage {

  private let coreDataStorage: CoreDataStorage = CoreDataStorage.shared

  private func fetchRequest() -> NSFetchRequest<SearchRequestEntity> {
    return SearchRequestEntity.fetchRequest()
  }

}

extension CoreDataQuerysStorage: QuerysStorage {
  func getSearchRecord(completion: @escaping (Result<[SearchRequestDTO]?, CoreDataStorageError>) -> Void) {
    let request = fetchRequest()

    coreDataStorage.performBackgroundTask { (context) in
      do {
        let entity = try context.fetch(request)
        completion(.success(entity.map { $0.toDTO() }))
      } catch {
        completion(.failure(.readError(error)))
      }

    }
  }

}
