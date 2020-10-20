//
//  SearchViewModel.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation

// ViewModel Actions which tells to coordinator when to present another views.
struct SearchViewModelActions {
  let showResult: ([Photo]) -> Void
}

protocol SearchViewModelInput {
  func viewDidLoad()
  func viewWillAppear()
  func fetchRemote(query: PhotosQuery)
  func fetchLocal(query: PhotosQuery)
}

protocol SearchViewModelOutput {
  var onRemotePhotosCompletion: ((Photos) -> Void)? { get set }
  var onLocalPhotosCompletion: ((Photos) -> Void)? { get set }
  var onSearchError: ((Error) -> Void)? { get set }
  var recordQuerys: [PhotosQuery]? { get set }
  var onRecordQuerysCompletion: (() -> Void)? { get set }
}

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput { }

final class DefaultSearchViewModel: SearchViewModel {

  // MARK: - Use cases
  // Tells viewModel which use case needs.
  typealias SearchUseCases = HasPhotosLocalSearchUseCase & HasPhotosRemoteSearchUseCase & HasSearchRecordUseCase
  private let useCases: SearchUseCases

  // MARK: - Actions
  private let actions: SearchViewModelActions?

  // MARK: - OUTPUT
  var onRemotePhotosCompletion: ((Photos) -> Void)?
  var onLocalPhotosCompletion: ((Photos) -> Void)?
  var onSearchError: ((Error) -> Void)?

  var onRecordQuerysCompletion: (() -> Void)?
  var recordQuerys: [PhotosQuery]?

  init(actions: SearchViewModelActions? = nil, useCases: SearchUseCases) {
    self.useCases = useCases
    self.actions = actions

  }
}

// MARK: - INPUT. View event methods
extension DefaultSearchViewModel {
  func viewDidLoad() {

  }

  func viewWillAppear() {
    // get search record values
    useCases.searchRecordUseCase?.getSearchRecord(completion: { [weak self] (photosQuerys, error) in
      if let error = error {
        self?.onSearchError?(error)
        return
      }

      self?.recordQuerys = photosQuerys
      self?.onRecordQuerysCompletion?()
    })
  }

  func fetchRemote(query: PhotosQuery) {

    useCases.searchRemoteUseCase?.search(query: query, completionHandler: { [weak self] (domain, error) in
      if let error = error {
        self?.onSearchError?(error)
        return
      }
      guard let photos = domain else { self?.onSearchError?(NSError(domain: "\(#function) nil", code: 0, userInfo: nil)); return }

      self?.onRemotePhotosCompletion?(photos)
      self?.actions?.showResult(photos.photo)
    })
  }

  func fetchLocal(query: PhotosQuery) {
    useCases.searchLocalUseCase?.search(query: query, completionHandler: { [weak self] (domain, error) in
      if let error = error {
        self?.onSearchError?(error)
        return
      }

      guard let photos = domain else { self?.onSearchError?(NSError(domain: "\(#function) nil", code: 0, userInfo: nil)); return }

      self?.onLocalPhotosCompletion?(photos)
    })
  }
}
