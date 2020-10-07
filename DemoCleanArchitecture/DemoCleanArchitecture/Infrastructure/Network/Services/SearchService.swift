//
//  SearchNetworkService.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/18.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import Moya

final class SearchService: DefaultService<FlickrAPIType, SearchResponseDTO, Photos> {

  let photosStorage = CoreDataPhotosStorage()

  // Override request method to do something you want of the subclass of DefaultService.
  override func request(targetType: FlickrAPIType, completion: @escaping (DefaultService<FlickrAPIType, SearchResponseDTO, Photos>.ReturnValueBase) -> Void) -> Cancellable {
    super.request(targetType: targetType) { result in

      // if can storage responses
      if let responseDTO = result.domain?.toDTO(),
        case .searchPhotos(let photoQuery) = targetType {
        self.photosStorage.save(response: .init(photos: responseDTO, stat: "storaged"), for: .init(query: photoQuery))
      }

      completion(result)
    }
  }
}

