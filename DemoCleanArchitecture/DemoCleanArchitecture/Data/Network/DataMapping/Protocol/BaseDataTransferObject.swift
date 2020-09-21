//
//  BaseDataTransferObject.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

/// Data transfer object of response
protocol BaseResponseDTO: Decodable {
  associatedtype DomainT: BaseEntities
  /// mapping to domain's entities
  func toDomain<T: BaseEntities>() -> T
}

/// Data transfer object of request
protocol BaseRequestDTO: Encodable {
  associatedtype QueryT
  
  init(query: QueryT)
}
