//
//  Repository.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/18.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation

protocol Repository {
  associatedtype DomainEntityT: BaseEntities
  associatedtype ServiceT

  /// Property of request's service, remember to set it **private(set)** or define it to a constant property.
  var service: ServiceT { get }

  /// Initializer, dependency injection
  init(service: ServiceT)

  // Actions of CRUD(Create, Read, Update, Delete)
  func get(id: Int, completionHandler: @escaping (DomainEntityT?, Error?) -> Void)
  func add(_ item: DomainEntityT, completionHandler: @escaping (Error?) -> Void)
  func delete(_ item: DomainEntityT, completionHandler: @escaping (Error?) -> Void)
  func edit(_ item: DomainEntityT, completionHandler: @escaping (Error?) -> Void)

  func list(completionHandler: @escaping ([DomainEntityT]?, Error?) -> Void)
}

extension Repository {

  func list(completionHandler: @escaping ([DomainEntityT]?, Error?) -> Void) {
    fatalError("Need to implements func \(#function) at \(type(of: self))\n")
  }

  func add(_ item: DomainEntityT, completionHandler: @escaping (Error?) -> Void) {
    fatalError("Need to implements func \(#function) at \(type(of: self))\n")
  }

  func delete(_ item: DomainEntityT, completionHandler: @escaping (Error?) -> Void) {
    fatalError("Need to implements func \(#function) at \(type(of: self))\n")
  }

  func edit(_ item: DomainEntityT, completionHandler: @escaping (Error?) -> Void) {
    fatalError("Need to implements func \(#function) at \(type(of: self))\n")
  }
}

/* define for reactive program
protocol CombineRepository {
    associatedtype T

    func get(id: Int) -> AnyPublisher<T, Error>
    func list() -> AnyPublisher<[T], Error>
    func add(_ item: T) -> AnyPublisher<Void, Error>
    func delete(_ item: T) -> AnyPublisher<Void, Error>
    func edit(_ item: T) -> AnyPublisher<Void, Error>
}
*/

enum RepositoryError: Error {
    case notFound
}

