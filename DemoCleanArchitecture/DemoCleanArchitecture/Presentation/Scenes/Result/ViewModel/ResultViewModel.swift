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
}

protocol ResultViewModelOutput {
  var onPhotosPrepared: ((String) -> Void)? { get set }
}

protocol ResultViewModel: ResultViewModelInput, ResultViewModelOutput { }

class DefaultResultViewModel: ResultViewModel {

  typealias PassValues = HasResultValues
  typealias ResultUseCase = HasSaveFavoriteUseCase & HasShowResultUseCase
  
  private let actions: ResultViewModelActions
  private let useCase: ResultUseCase

  // MARK: - OUTPUT
  var onPhotosPrepared: ((String) -> Void)?

  init(useCase: ResultUseCase, actions: ResultViewModelActions) {
    self.useCase = useCase
    self.actions = actions
  }
}

// MARK: - INPUT. View event methods
extension DefaultResultViewModel {
    func viewDidLoad() {
      // photos
      var allStrings: String = ""

      useCase.showResultUseCase?
        .fetchResult()
        .photos
        .map { "id: \($0.id), owner: \($0.owner ?? ""), title: \($0.title ?? "")" }
        .forEach { allStrings.append($0 + "\n") }

      onPhotosPrepared?(allStrings)
    }
}
