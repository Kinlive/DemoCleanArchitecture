//
//  SearchRequestEntity+Mapping.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/19.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

extension SearchRequestEntity {
  func toDTO() -> SearchRequestDTO {
    return .init(query: toDomain())
  }

  func toDomain() -> PhotosQuery {
    
    return .init(
      searchText: text ?? "",
      perPage: Int(perPage),
      page: Int(page),
      createDate: createTime)
  }
}

