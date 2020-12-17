//
//  SearchRepository.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/18.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

final class DefaultSearchRepository: SearchRepository {

  typealias Dependencies = HasSearchRemoteService & HasCoreDataService & HasQuerysStorage

  let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  func request(searchQuery: PhotosQuery, completionHandler: @escaping (Photos?, Error?) -> Void) {

    let _ = dependencies.searchService?.request(targetType: .searchPhotos(parameter: searchQuery)) { [weak self] returnValues in
      // storage search response
      if let responseDTO = returnValues.responseDTO as? SearchResponseDTO {
        self?.dependencies.photosStorage.save(
          response: responseDTO,
          for: .init(query: searchQuery)
        )
      }

      completionHandler(returnValues.responseDTO?.toDomain(), returnValues.error)
    }
  }

  func storage(searchQuery: PhotosQuery, completionHandler: @escaping (Photos?, Error?) -> Void) {

    dependencies.photosStorage.getResponse(for: SearchRequestDTO(query: searchQuery)) { (result) in
      switch result {
      case .success(let responseDTO): completionHandler(responseDTO?.toDomain(), nil)
      case .failure(let error): completionHandler(nil, error)
      }
    }
  }

  func recordQuerys(completionHandler: @escaping ([PhotosQuery], Error?) -> Void) {
    dependencies.querysStorage.getSearchRecord { (result) in
      switch result {
      case .success(let querysDTO): completionHandler(querysDTO?.compactMap { $0.toDomain() } ?? [], nil)
      case .failure(let error): completionHandler([], error)
      }
    }
  }
}
