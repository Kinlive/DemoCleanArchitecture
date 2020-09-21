//
//  PhotosQuery.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

struct PhotosQuery: Equatable {

  let searchText: String
  let perPage: Int
  let page: Int

}
