//
//  PhotoResponseEntity+Mapping.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/15.
//  Copyright © 2020 KinWei. All rights reserved.
//

import CoreData

extension SearchResponseDTO.PhotosDTO.PhotoDTO {
  @discardableResult
  func toFavoriteEntity(in context: NSManagedObjectContext) -> SearchPhotoResponseEntity {
    let entity: SearchPhotoResponseEntity = toEntity(in: context)
    entity.isFavorite = true
    return entity
  }
}
