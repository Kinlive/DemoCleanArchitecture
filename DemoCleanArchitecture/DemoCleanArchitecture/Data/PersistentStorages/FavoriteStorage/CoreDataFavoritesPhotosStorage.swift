//
//  CoreDataFavoritesPhotosStorage.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import CoreData

class CoreDataFavoritesPhotosStorage {

  private let coreDataStorage: CoreDataStorage = CoreDataStorage.shared

  private func fetchAllRequest() -> NSFetchRequest<SearchPhotoResponseEntity> {
    let request: NSFetchRequest = SearchPhotoResponseEntity.fetchRequest()
    request.predicate = NSPredicate(
      format: "%K = %@",
      #keyPath(SearchPhotoResponseEntity.isFavorite), NSNumber(booleanLiteral: true))
    // Notice: If attribute was bool, must use NSNumber wrap of bool or use %d to compare int: true -> 1, false -> 0

    return request
  }

  private func deleteResponse(for response: SearchResponseDTO.PhotosDTO.PhotoDTO, in context: NSManagedObjectContext) throws {
    let request = fetchAllRequest()

    do {
      let results = try context.fetch(request)
      results
        .filter { $0.id == response.id }
        .forEach { context.delete($0) } // avoid repeat to write data

    } catch {
      throw error
    }
  }

}

extension CoreDataFavoritesPhotosStorage: FavoritesPhotosStorage {
  func save(response: SearchResponseDTO.PhotosDTO.PhotoDTO) {
    coreDataStorage.performBackgroundTask { [weak self] context in
      do {
        try self?.deleteResponse(for: response, in: context)
        // write favorite data in context.
        response.toFavoriteEntity(in: context)

        try context.save()

      } catch {
        debugPrint("CoreDataFavoritePhotos error \(error), \((error as NSError).userInfo)")
      }
    }
  }

  func loadAll(completion: @escaping (Result<[Photo], CoreDataStorageError>) -> Void) {
    coreDataStorage.performBackgroundTask { context in
      do {
        let fetchAllRequest = self.fetchAllRequest()
        let responseEntity = try context.fetch(fetchAllRequest)
        let domainPhotos = responseEntity.compactMap { $0.toDTO() }.map { $0.toDomain() as Photo }

        completion(.success(domainPhotos))

      } catch {
        completion(.failure(CoreDataStorageError.readError(error)))
      }
    }
  }
}
