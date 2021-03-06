//
//  FavoritePhotoEntity+Mapping.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/30.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import CoreData

extension FavoritePhotoEntity {
  func toDTO() -> SearchResponseDTO.PhotosDTO.PhotoDTO {
    return .init(
      id: id ?? "",
      owner: owner,
      secret: secret,
      server: server,
      farm: Int(farm),
      title: title,
      ispublic: Int(ispublic),
      isfriend: Int(isfriend),
      isfamily: Int(isfamily)
    )
  }
}

extension SearchResponseDTO.PhotosDTO.PhotoDTO {
  func toFavoriteEntity(in context: NSManagedObjectContext) -> FavoritePhotoEntity {
    let entity = FavoritePhotoEntity(context: context)
    entity.farm = Int32(farm)
    entity.id = id
    entity.isfamily = Int32(isfamily)
    entity.ispublic = Int32(ispublic)
    entity.isfriend = Int32(isfriend)
    entity.owner = owner
    entity.secret = secret
    entity.server = server
    entity.title = title

    return entity
    
  }
}
