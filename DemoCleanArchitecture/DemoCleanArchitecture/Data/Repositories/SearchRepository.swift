//
//  SearchRepository.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/18.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

class SearchRepository: Repository {
  typealias ServiceT = SearchServcice

  typealias DomainEntityT = Photos


  var service: SearchServcice

  required init(service: SearchServcice) {
    self.service = service
  }

  func get(id: Int, completionHandler: @escaping (Photos?, Error?) -> Void) {

  }

}
