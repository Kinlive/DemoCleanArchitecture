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
  typealias ResultUseCase = HasSaveFavoriteUseCase & HasShowResultUseCase & HasFetchFavoriteUseCase & HasRemoveFavoriteUseCase
  
  private let actions: ResultViewModelActions
  private let useCase: ResultUseCase

  // MARK: - OUTPUT
  var onPhotosPrepared: ((String) -> Void)?
  var onPhotoSaved: ((IndexPath) -> Void)?
  var onPhotoSavedError: ((String) -> Void)?
  var onFetchFavoritesError: ((Error) -> Void)?
  var photos: [Photo]?
  var favoritePhotos: [Photo]?

  init(useCase: ResultUseCase, actions: ResultViewModelActions) {
    self.useCase = useCase
    self.actions = actions
  }

  private func fetchPhotosAndFavorites(indexPath: IndexPath? = nil) {

    useCase.fetchFavoriteUseCase?.fetchFavorite(completion: { [weak self] result in
      switch result {
      case .success(let favorites):

        let searchText = self?.useCase.showResultUseCase?.fetchResult().resultQuery?.searchText ?? ""
        self?.favoritePhotos = favorites[searchText]

        self?.photos = self?.useCase.showResultUseCase?.fetchResult().photos
        self?.onPhotosPrepared?("")

        // trigger when saved success.
        if let indexPath = indexPath {
          self?.onPhotoSaved?(indexPath)
        }

      case .failure(let error):
        self?.onFetchFavoritesError?(error)
      }
    })
  }
}

// MARK: - INPUT. View event methods
extension DefaultResultViewModel {
  func viewDidLoad() {
    // photos
    fetchPhotosAndFavorites()
  }

  func addFavorite(of indexPath: IndexPath) {

    guard let photo = photos?[indexPath.row],
      let resultQuery = useCase.showResultUseCase?.fetchResult().resultQuery else { return }

    useCase.saveFavoriteUseCase?.save(favorite: photo, of: resultQuery) { [weak self ] error in

      guard error == nil else { self?.onPhotoSavedError?(error.debugDescription); return }

      // refresh data
      self?.fetchPhotosAndFavorites(indexPath: indexPath)

    }
  }

  func removeFavorite(of indexPath: IndexPath) {

    guard let photo = photos?[indexPath.row] else { return }

    useCase.removeFavoriteUseCase?.remove(favorite: photo, completion: { [weak self] error in
      guard error == nil else { self?.onPhotoSavedError?(error.debugDescription); return }
      // refresh data for update cells
      self?.fetchPhotosAndFavorites(indexPath: indexPath)
    })
  }
}
