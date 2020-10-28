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
  func viewWillAppear()
  func onTappedHeader(isExpanding: Bool, of section: Int)
  func onDeleteFavorite(at indexPath: IndexPath)
}

protocol FavoriteViewModelOutput {
  var tappedHeaderOn: ((_ isExpanding: Bool, _ indexPaths: [IndexPath]) -> Void)? { get set }
  var onFetchError: ((String) -> Void)? { get set }
  var onFavoritesPrepared: (() -> Void)? { get set }

  func photo(at indexPath: IndexPath) -> Photo
  func numberOfPhotos(in section: Int) -> Int
  func numberOfSection() -> Int
  func headerTitle(in section: Int) -> String?
}

protocol FavoriteViewModel: FavoriteViewModelInput, FavoriteViewModelOutput { }

class DefaultFavoriteViewModel: FavoriteViewModel {

  typealias UseCases = HasFetchFavoriteUseCase & HasRemoveFavoriteUseCase

  // MARK: - OUTPUT
  var tappedHeaderOn: ((Bool, [IndexPath]) -> Void)?
  var onFetchError: ((String) -> Void)?
  var onFavoritesPrepared: (() -> Void)?

  // MARK: - Properties
  private let useCases: UseCases
  private let actions: FavoriteViewModelActions

  private var fetchFavorites: [(title: String, photos: [Photo])] = []
  private var expandsIndex: [Int : Bool] = [:]

  init(actions: FavoriteViewModelActions, useCases: UseCases) {
    self.actions = actions
    self.useCases = useCases
  }

  // MARK: - Output methods.
  func photo(at indexPath: IndexPath) -> Photo {
    return fetchFavorites[indexPath.section].photos[indexPath.row]
  }

  func headerTitle(in section: Int) -> String? {
    return fetchFavorites[section].title
  }

  func numberOfPhotos(in section: Int) -> Int {
    guard let isExpanding = expandsIndex[section] else { return 0 }

    return isExpanding ? fetchFavorites[section].photos.count : 0
  }

  func numberOfSection() -> Int {
    return fetchFavorites.count
  }

}

// MARK: - INPUT. View event methods
extension DefaultFavoriteViewModel {
  func viewDidLoad() {
  }

  func viewWillAppear() {
    useCases.fetchFavoriteUseCase?.fetchFavorite(completion: { [weak self] result in

      // clear first
      self?.fetchFavorites.removeAll()
      self?.expandsIndex.removeAll()

      switch result {
      case .success(let photos):

        photos
          .sorted(by: { $0.key > $1.key })
          .enumerated()
          .forEach { (index, element ) in

            self?.fetchFavorites.append((element.key, element.value))
            // according count of photos, base set each to false.
            self?.expandsIndex[index] = true
        }

        // trigger favorites prepared for reload table.
        self?.onFavoritesPrepared?()

      case .failure(let error):
        self?.onFetchError?(error.localizedDescription)
      }
    })

  }

  func onTappedHeader(isExpanding: Bool, of section: Int) {
    // cache section
    expandsIndex[section] = isExpanding
    let indexPathCount = fetchFavorites[section].photos.count

    let indexPaths = (0..<indexPathCount)
      .map { IndexPath(item: $0, section: section) }

    tappedHeaderOn?(isExpanding, indexPaths)
  }

  func onDeleteFavorite(at indexPath: IndexPath) {

    let deletePhoto = fetchFavorites[indexPath.section].photos[indexPath.row]
    useCases.removeFavoriteUseCase?.remove(favorite: deletePhoto, completion: { [weak self] error in
      guard let error = error else { self?.viewWillAppear(); return }
      self?.onFetchError?(error.localizedDescription)
    })
  }
}
