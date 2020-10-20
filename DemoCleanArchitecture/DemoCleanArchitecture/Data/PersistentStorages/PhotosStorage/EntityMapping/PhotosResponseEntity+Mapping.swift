//
//  PhotosResponseEntity+Mapping.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/6.
//  Copyright © 2020 KinWei. All rights reserved.
//

import CoreData

// MARK: - Entity to Data transfer object
extension SearchResponseEntity {
  func toDTO() -> SearchResponseDTO {
    return SearchResponseDTO(
      photos: photos?.toDTO(),
      stat: stat ?? "")
  }

}

extension SearchPhotosResponseEntity {
  func toDTO() -> SearchResponseDTO.PhotosDTO {
    return .init(
      page: Int(page),
      pages: Int(pages),
      perpage: Int(perpage),
      total: total,
      photo: photo?.allObjects.map { ($0 as! SearchPhotoResponseEntity).toDTO() } ?? []
    )
  }
}

extension SearchPhotoResponseEntity {
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
      isfamily: Int(isfamily),
      isFavorite: isFavorite
    )
  }
}

// MARK: - toEntity() for DTOs.
extension SearchResponseDTO {
  func toEntity(in context: NSManagedObjectContext) -> SearchResponseEntity {
    let entity: SearchResponseEntity = .init(context: context)
    entity.stat = stat
    entity.photos = photos?.toEntity(in: context)
    return entity
  }
}

extension SearchResponseDTO.PhotosDTO {
  func toEntity(in context: NSManagedObjectContext) -> SearchPhotosResponseEntity {
    let entity: SearchPhotosResponseEntity = .init(context: context)
    entity.page = Int32(page)
    entity.pages = Int32(pages)
    entity.perpage = Int32(perpage)
    photo.forEach { entity.addToPhoto($0.toEntity(in: context)) }
    return entity
  }
}

extension SearchResponseDTO.PhotosDTO.PhotoDTO {
  func toEntity(in context: NSManagedObjectContext) -> SearchPhotoResponseEntity {
    let entity: SearchPhotoResponseEntity = .init(context: context)
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

extension SearchRequestDTO {
  func toEntity(in context: NSManagedObjectContext) -> SearchRequestEntity {
    let entity: SearchRequestEntity = .init(context: context)
    entity.page = Int32(page)
    entity.perPage = Int32(perPage)
    entity.text = text
    entity.createTime = Date()

    return entity
  }
}
