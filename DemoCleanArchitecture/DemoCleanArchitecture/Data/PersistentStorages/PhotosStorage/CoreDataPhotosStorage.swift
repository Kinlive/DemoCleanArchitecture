//
//  CoreDataPhotosStorage.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/6.
//  Copyright © 2020 KinWei. All rights reserved.
//

import CoreData

final class CoreDataPhotosStorage {

  let coreDataStorage = CoreDataStorage.shared

  private func fetchRequest(for requestDTO: SearchRequestDTO) -> NSFetchRequest<SearchRequestEntity> {
    let request: NSFetchRequest = SearchRequestEntity.fetchRequest()
    request.predicate = NSPredicate(
      format: "%K = %@ AND (%K = %d AND %K = %d)",
      #keyPath(SearchRequestEntity.text), requestDTO.text,
      #keyPath(SearchRequestEntity.page), requestDTO.page,
      #keyPath(SearchRequestEntity.perPage), requestDTO.perPage
    )

    return request
  }

  private func deleteResponse(for requestDTO: SearchRequestDTO, in context: NSManagedObjectContext) throws {
    let request = fetchRequest(for: requestDTO)

    do {
      if let result = try context.fetch(request).first {
        context.delete(result)
      }
    } catch {
      throw error
    }
  }

  private func findSameRequest(for requestDTO: SearchRequestDTO, in context: NSManagedObjectContext) throws -> SearchRequestEntity {
    let request: NSFetchRequest = SearchRequestEntity.fetchRequest()

    do {
      return try context.fetch(request)
        .filter { $0.text == requestDTO.text }
        .first ?? requestDTO.toEntity(in: context)

    } catch {
      throw error
    }
  }

}

extension CoreDataPhotosStorage: PhotosStorage {

  func getResponse(for requestDTO: SearchRequestDTO, completion: @escaping (Result<SearchResponseDTO?, CoreDataStorageError>) -> Void) {
    coreDataStorage.performBackgroundTask { [weak self] (context) in
      guard let `self` = self else { completion(.failure(.readError(NSError(domain: "at \(#function) self was not found", code: 0, userInfo: nil)))) ;return }
      do {
        let fetchRequest = self.fetchRequest(for: requestDTO)
        let requestEntity = try context.fetch(fetchRequest).first
        completion(.success(requestEntity?.response?.toDTO()))
      } catch {
        completion(.failure(CoreDataStorageError.readError(error)))
      }
    }
  }

  func save(response: SearchResponseDTO, for requestDTO: SearchRequestDTO) {
    coreDataStorage.performBackgroundTask { [weak self] context in

      do {

        let requestEntity = try self?.findSameRequest(for: requestDTO, in: context)
        // if find save request and its response had old values.
        // To avoid saved repeat response here will delete the old.
        if let oldResponse = requestEntity?.response {
          context.delete(oldResponse)
          try context.save()
        }
        // And give the request new response.
        requestEntity?.response = response.toEntity(in: context)

        try context.save()

      } catch {
        debugPrint("CoreDataPhotosStorage error \(error), \((error as NSError).userInfo)")
      }
    }
  }

}

