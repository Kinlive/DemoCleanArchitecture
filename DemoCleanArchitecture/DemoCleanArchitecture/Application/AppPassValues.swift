//
//  AppPassValues.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol HasResultValues {
  var resultQuery: PhotosQuery? { get }
}

protocol HasFavoriteValues {
  var favorite: [String] { get }
}
protocol HasSearchRecordValues {
  var photosQuery: [PhotosQuery] { get }
}

struct AppPassValues: HasResultValues, HasFavoriteValues, HasSearchRecordValues {
  let favorite: [String]
  let photosQuery: [PhotosQuery]
  let resultQuery: PhotosQuery?

  init(resultQuery: PhotosQuery? = nil, favorite: [String] = [], photosQuery: [PhotosQuery] = []) {
    self.resultQuery = resultQuery
    self.favorite = favorite
    self.photosQuery = photosQuery
  }
}
