//
//  SearchRepository.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/28.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol SearchRepository {
  func request(searchQuery: PhotosQuery, completionHandler: @escaping (Photos?, Error?) -> Void)
  func storage(searchQuery: PhotosQuery, completionHandler: @escaping (Photos?, Error?) -> Void)
  func recordQuerys(completionHandler: @escaping ([PhotosQuery], Error?) -> Void)

}
