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

  private func deleteFavorite(for response: SearchResponseDTO.PhotosDTO.PhotoDTO, in context: NSManagedObjectContext) throws {
    let request = fetchAllRequest()

    do {
      let results = try context.fetch(request)
      results
        .filter { $0.id == response.id }
        .forEach { $0.isFavorite = false }

    } catch {
      throw error
    }
  }

  private func findSameRequest(for request: SearchRequestDTO, in context: NSManagedObjectContext) throws -> SearchRequestEntity? {
    let fetchRequest: NSFetchRequest = SearchRequestEntity.fetchRequest()
    do {
      let results = try context.fetch(fetchRequest)
      return results
        .filter { $0.text == request.text }
        .first ?? request.toEntity(in: context) // if not found same request on storaged then new one for it

    } catch {
      throw error
    }
  }

  private func findSamePhoto(for response: SearchResponseDTO.PhotosDTO.PhotoDTO, in context: NSManagedObjectContext) throws -> SearchPhotoResponseEntity? {
    let fetchRequest: NSFetchRequest = SearchPhotoResponseEntity.fetchRequest()

    do {
      let results = try context.fetch(fetchRequest)
      return results
        .filter { $0.id == response.id }
        .first ?? response.toEntity(in: context)  // if not found same request on storaged then new one for it

    } catch {
      throw error
    }
  }

}

extension CoreDataFavoritesPhotosStorage: FavoritesPhotosStorage {
  func save(response: SearchResponseDTO.PhotosDTO.PhotoDTO,
            of request: SearchRequestDTO,
            completion: @escaping (CoreDataStorageError?) -> Void) {

    coreDataStorage.performBackgroundTask { [weak self] context in
      do {
        // find storaged response who same with import's response that edit favorite in context.
        let photoEntity = try self?.findSamePhoto(for: response, in: context)
        // mark favorite
        photoEntity?.isFavorite = true

        // dependency with request
        photoEntity?.request = try self?.findSameRequest(for: request, in: context)

        try context.save()
        completion(nil)

      } catch {
        completion(.saveError(error))
      }
    }
  }

  func fetchAllFavorite(completion: @escaping (Result<[String : [SearchResponseDTO.PhotosDTO.PhotoDTO]], CoreDataStorageError>) -> Void) {
    coreDataStorage.performBackgroundTask { context in
      do {
        let fetchAllRequest = self.fetchAllRequest()
        let responseEntity = try context.fetch(fetchAllRequest)

        var dic: [String : [SearchResponseDTO.PhotosDTO.PhotoDTO]] = [:]

        responseEntity
          .map { ($0.request?.text, $0) }
          .forEach { searchText, photoEntity in

            guard let text = searchText else { return }
            let photo = photoEntity.toDTO()

            dic[text] == nil
              ? dic[text] = [photo]
              : dic[text]?.append(photo)

          }

        completion(.success(dic))

      } catch {
        completion(.failure(CoreDataStorageError.readError(error)))
      }
    }
  }

  func remove(response: SearchResponseDTO.PhotosDTO.PhotoDTO, completion: @escaping (CoreDataStorageError?) -> Void) {
    coreDataStorage.performBackgroundTask { [weak self] context in
      do {
        try self?.deleteFavorite(for: response, in: context)
        try context.save()

        completion(nil)
      } catch {
        completion(.deleteError(error))
      }
    }
  }
}
