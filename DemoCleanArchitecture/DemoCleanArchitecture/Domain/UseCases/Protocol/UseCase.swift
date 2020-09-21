//
//  UseCase.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/18.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol UseCase {

  associatedtype ImplementedRepository
  var repository: ImplementedRepository { get }

  init(repo: ImplementedRepository)
}
