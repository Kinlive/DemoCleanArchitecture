//
//  Photos.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

struct Photos: BaseEntities {
  typealias Identifier = String

  let id: Identifier
  let page, pages, perpage: Int
  let total: String
  let photo: [Photo]
}


struct Photo: BaseEntities {
  typealias Identifier = String
  let id: Identifier
  let owner, secret, server: String
  let farm: Int
  let title: String
  let ispublic, isfriend, isfamily: Int
}
