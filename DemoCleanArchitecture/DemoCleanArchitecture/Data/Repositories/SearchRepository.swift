//
//  SearchRepository.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/18.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import Moya

final class SearchRepository {

//  typealias ServiceT = SearchService
//  typealias DomainEntityT = Photos
  typealias Dependencies = HasSearchRemoteService & HasCoreDataService

  //let service: SearchService

  let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  @discardableResult
  func request(searchQuery: PhotosQuery, completionHandler: @escaping (Photos?, Error?) -> Void) -> Cancellable {

    return dependencies.searchService.request(targetType: .searchPhotos(parameter: searchQuery)) { [weak self] returnValues in
      // storage search response
      if let responseDTO = returnValues.domain?.toDTO() {
        self?.dependencies.photosStorage.save(
          response: .init(photos: responseDTO, stat: "storaged"),
          for: .init(query: searchQuery)
        )
      }

      completionHandler(returnValues.domain, returnValues.error)
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
}
