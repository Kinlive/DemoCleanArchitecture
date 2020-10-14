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
  func request(search: String, completionHandler: @escaping (Photos?, Error?) -> Void) -> Cancellable {

    let query = PhotosQuery(searchText: search, perPage: 3, page: 1)

    return dependencies.searchService.request(targetType: .searchPhotos(parameter: query)) { [weak self] returnValues in
      // storage search response
      if let responseDTO = returnValues.domain?.toDTO() {
        self?.dependencies.photosStorage.save(
          response: .init(photos: responseDTO, stat: "storaged"),
          for: .init(query: query)
        )
      }

      completionHandler(returnValues.domain, returnValues.error)
    }
  }

  func storage(search: String, completionHandler: @escaping (Photos?, Error?) -> Void) {
    let query = PhotosQuery(searchText: search, perPage: 10, page: 1)

    dependencies.photosStorage.getResponse(for: SearchRequestDTO(query: query)) { (result) in
      switch result {
      case .success(let responseDTO): completionHandler(responseDTO?.toDomain(), nil)
      case .failure(let error): completionHandler(nil, error)
      }
    }
  }
}
