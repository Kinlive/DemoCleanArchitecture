//
//  AppPassValues.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol HasResultValues {
  var photos: [Photo] { get }
}

protocol HasFavoriteValues {
  var favorite: [String] { get }
}

struct AppPassValues: HasResultValues, HasFavoriteValues {
  let photos: [Photo]
  let favorite: [String]

  init(photos: [Photo] = [], favorite: [String] = []) {
    self.photos = photos
    self.favorite = favorite
  }
}
