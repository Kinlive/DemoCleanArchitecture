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
  
}

protocol SearchViewModelInput {
    func viewDidLoad()
}

protocol SearchViewModelOutput {

}

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput { }

final class DefaultSearchViewModel: SearchViewModel {

  // MARK: - Use cases
  // Tells viewModel which use case needs.
  typealias SearchUseCases = HasPhotosLocalSearchUseCase & HasPhotosRemoteSearchUseCase
  private let useCases: SearchUseCases

  // MARK: - Actions
  private let actions: SearchViewModelActions?
  
  // MARK: - Input

  // MARK: - OUTPUT


  init(actions: SearchViewModelActions? = nil, useCases: SearchUseCases) {
    self.useCases = useCases
    self.actions = actions

  }
}

// MARK: - INPUT. View event methods
extension DefaultSearchViewModel {
  func viewDidLoad() {
  }
}
