//
//  ResultViewModel.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation

struct ResultViewModelActions {

}

protocol ResultViewModelInput {
  func viewDidLoad()
  func viewWillAppear()
  func addFavorite(of indexPath: IndexPath)
  func removeFavorite(of indexPath: IndexPath)
}

protocol ResultViewModelOutput {
  var onPhotosPrepared: ((String) -> Void)? { get set }
  var onPhotoSaved: ((IndexPath) -> Void)? { get set }
  var onPhotoSavedError: ((String) -> Void)? { get set }

  var photos: [Photo]? { get set }
  var favoritePhotos: [Photo]? { get set }
}

protocol ResultViewModel: ResultViewModelInput, ResultViewModelOutput { }

class DefaultResultViewModel: ResultViewModel {

  typealias PassValues = HasResultValues
  typealias ResultUseCase = HasSaveFavoriteUseCase & HasPhotosRemoteSearchUseCase & HasFetchFavoriteUseCase & HasRemoveFavoriteUseCase
  
  private let actions: ResultViewModelActions
  private let useCase: ResultUseCase
  private let passValues: PassValues

  private let dispatchGroup = DispatchGroup()

  // MARK: - OUTPUT
  var onPhotosPrepared: ((String) -> Void)?
  var onPhotoSaved: ((IndexPath) -> Void)?
  var onPhotoSavedError: ((String) -> Void)?
  var onFetchFavoritesError: ((Error) -> Void)?
  var photos: [Photo]?
  var favoritePhotos: [Photo]?

  init(useCase: ResultUseCase, actions: ResultViewModelActions, passValues: PassValues) {
    self.useCase = useCase
    self.actions = actions
    self.passValues = passValues
  }

  private func updateFavorites(of query: PhotosQuery, at indexPath: IndexPath? = nil) {
    dispatchGroup.enter()
    useCase.fetchFavoriteUseCase?.fetchFavorite(completion: { [weak self] result in
      switch result {
      case .success(let favorites):
        self?.favoritePhotos = favorites[query.searchText]

        // trigger when saved success.
        if let indexPath = indexPath {
          self?.onPhotoSaved?(indexPath)
        }

      case .failure(let error):
        self?.onFetchFavoritesError?(error)

      }
      self?.dispatchGroup.leave()
    })
  }

  private func fetchPhotos(of query: PhotosQuery) {
    dispatchGroup.enter()
    useCase.searchRemoteUseCase?.search(query: query, completionHandler: { [ weak self] (photos, error) in
      if let error = error {
        self?.onFetchFavoritesError?(error)
        self?.dispatchGroup.leave()
        return
      }
      guard let photos = photos else {
        self?.dispatchGroup.leave()
        return
      }
      self?.photos = photos.photo.sorted(by: { $0.id > $1.id })
      self?.dispatchGroup.leave()
    })

  }
}

// MARK: - INPUT. View event methods
extension DefaultResultViewModel {
  func viewDidLoad() {

  }

  func viewWillAppear() {
    guard let query = passValues.resultQuery else { return }
    fetchPhotos(of: query)
    updateFavorites(of: query)

    dispatchGroup.notify(queue: .main) { [weak self] in
      self?.onPhotosPrepared?("")
    }
  }

  func addFavorite(of indexPath: IndexPath) {

    guard let photo = photos?[indexPath.row],
      let query = passValues.resultQuery else { return }

    useCase.saveFavoriteUseCase?.save(favorite: photo, of: query) { [weak self ] error in

      guard error == nil else { self?.onPhotoSavedError?(error.debugDescription); return }

      // refresh data
      self?.updateFavorites(of: query, at: indexPath)
    }
  }

  func removeFavorite(of indexPath: IndexPath) {

    guard let photo = photos?[indexPath.row], let query = passValues.resultQuery else { return }

    useCase.removeFavoriteUseCase?.remove(favorite: photo, completion: { [weak self] error in
      guard error == nil else { self?.onPhotoSavedError?(error.debugDescription); return }
      // refresh data for update cells
      self?.updateFavorites(of: query, at: indexPath)
    })
  }
}
