//
//  FavoriteViewModel.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation

struct FavoriteViewModelActions {

}

protocol FavoriteViewModelInput {
  func viewDidLoad()
  func onTappedHeader(isExpanding: Bool, of section: Int)
}

protocol FavoriteViewModelOutput {
  var favorites: [Photo]? { get set }
  var tappedHeaderOn: ((_ isExpanding: Bool, _ section: Int) -> Void)? { get set }
  var onFetchError: ((String) -> Void)? { get set }
  func photos(at indexPath: IndexPath) -> [Photo]
}

protocol FavoriteViewModel: FavoriteViewModelInput, FavoriteViewModelOutput { }

class DefaultFavoriteViewModel: FavoriteViewModel {

  typealias UseCases = HasFetchFavoriteUseCase & HasRemoveFavoriteUseCase

  // MARK: - OUTPUT
  var favorites: [Photo]?
  var tappedHeaderOn: ((Bool, Int) -> Void)?
  var onFetchError: ((String) -> Void)?

  private let useCases: UseCases
  private let actions: FavoriteViewModelActions
  private var fetchFavorites: [(title: String, photos: [Photo])] = []
  private var expendsIndex: [Int : Bool] = [:]

  init(actions: FavoriteViewModelActions, useCases: UseCases) {
    self.actions = actions
    self.useCases = useCases
  }

  func photos(at indexPath: IndexPath) -> [Photo] {
    guard let isExpanding = expendsIndex[indexPath.section] else { return [] }
    if isExpanding {
      return fetchFavorites[indexPath.section].photos
    } else {
      return []
    }
  }
}

// MARK: - INPUT. View event methods
extension DefaultFavoriteViewModel {
  func viewDidLoad() {
    useCases.fetchFavoriteUseCase?.fetchFavorite(completion: { [weak self] result in
      switch result {
      case .success(let photos):
        print("Fetch favorites =========================")
        photos.keys.forEach { key in
          print("Key: \(key)")
          print("Photos XXXXXX: \n\(photos[key])")
        }
        print("=========================================")
      case .failure(let error):
        self?.onFetchError?(error.localizedDescription)
      }
    })
  }

  func onTappedHeader(isExpanding: Bool, of section: Int) {
    // cache section
    expendsIndex[section] = isExpanding
    tappedHeaderOn?(isExpanding, section)
  }
}
