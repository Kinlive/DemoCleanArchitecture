//
//  EncoableExtension.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/21.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
