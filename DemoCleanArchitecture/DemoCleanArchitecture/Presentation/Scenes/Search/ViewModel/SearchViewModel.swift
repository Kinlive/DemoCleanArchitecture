//
//  SearchViewModel.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation

struct SearchViewModelActions {
  
}

protocol SearchViewModelInput {
    func viewDidLoad()
}

protocol SearchViewModelOutput {
  var testTitle: String { get }
}

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput { }

final class DefaultSearchViewModel: SearchViewModel {
    
    // MARK: - OUTPUT
  var testTitle: String

  init(testTitle: String) {
    self.testTitle = testTitle
  }
}

// MARK: - INPUT. View event methods
extension DefaultSearchViewModel {
    func viewDidLoad() {
    }
}
