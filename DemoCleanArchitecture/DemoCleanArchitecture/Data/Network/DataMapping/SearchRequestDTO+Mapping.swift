//
//  SearchRequestDTO+Mapping.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

struct SearchRequestDTO: BaseRequestDTO {
  typealias QueryT = PhotosQuery

  enum CodingKeys: String, CodingKey {
    case method, format, nojsoncallback
    case apiKey = "api_key"
    case text
    case perPage = "per_page"
    case page
  }

  let method: String = "flickr.photos.search"
  let apiKey: String = "2d56edc1b27ddecc287336edac52ddba"
  let format: String = "json"
  let nojsoncallback: String = "1"

  let text: String
  let perPage: Int
  let page: Int

  init(query: PhotosQuery) {
    self.text = query.searchText
    self.perPage = query.perPage
    self.page = query.page
  }

}
