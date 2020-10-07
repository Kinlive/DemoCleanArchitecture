//
//  PhotosStorage.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/6.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol PhotosStorage {
  func getResponse(for requestDTO: SearchRequestDTO, completion: @escaping (Result<SearchResponseDTO?, CoreDataStorageError>) -> Void)
  func save(response: SearchResponseDTO, for requestDTO: SearchRequestDTO)
}
