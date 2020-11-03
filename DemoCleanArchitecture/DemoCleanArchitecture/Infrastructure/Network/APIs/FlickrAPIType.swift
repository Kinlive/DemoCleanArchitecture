//
//  FlickrAPIType.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/18.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import Moya

enum FlickrAPIType {
  case searchPhotos(parameter: PhotosQuery)
}

extension FlickrAPIType: TargetType {
  
  var baseURL: URL { URL(string: "https://www.flickr.com/services/")! }

  var path: String { "rest/" }

  var method: Moya.Method { .post }

  var sampleData: Data { sampleJSON.data(using: .utf8)! }

  var task: Task {
    switch self {
    case .searchPhotos(let parameter):
      let dto = SearchRequestDTO(query: parameter)
      let dic = (try? dto.asDictionary()) ?? [:]

      return .requestCompositeParameters(bodyParameters: [:], bodyEncoding: JSONEncoding.default, urlParameters: dic)
    }
  }

  var headers: [String : String]? {
    [
      "Content-Type" : "application/json"
    ]
  }
}

private let sampleJSON: String =
"""
  {
      "photos": {
          "page": 1,
          "pages": 21596,
          "perpage": 10,
          "total": "215951",
          "photo": [
              {
                  "id": "9999999999",
                  "owner": "sample owner",
                  "secret": "sample secret",
                  "server": "sample server",
                  "farm": 66,
                  "title": "sample use ",
                  "ispublic": 1,
                  "isfriend": 0,
                  "isfamily": 0
              }
          ]
      },
      "stat": "ok"
  }
"""
