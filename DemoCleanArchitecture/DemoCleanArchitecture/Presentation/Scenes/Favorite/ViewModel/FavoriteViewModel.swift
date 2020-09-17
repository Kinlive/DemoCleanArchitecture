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
}

protocol FavoriteViewModelOutput {
  var title: String { get }
}

protocol FavoriteViewModel: FavoriteViewModelInput, FavoriteViewModelOutput { }

class DefaultFavoriteViewModel: FavoriteViewModel {
  // Output
  var title: String


  init(actions: FavoriteViewModelActions, testTitle: String) {
    self.title = testTitle
  }
  // MARK: - OUTPUT

}

// MARK: - INPUT. View event methods
extension DefaultFavoriteViewModel {
    func viewDidLoad() {
    }
}
