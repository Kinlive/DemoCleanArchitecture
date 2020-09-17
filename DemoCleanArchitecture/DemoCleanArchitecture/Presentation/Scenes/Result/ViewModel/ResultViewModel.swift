//
//  ResultViewModel.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation

protocol ResultViewModelInput {
    func viewDidLoad()
}

protocol ResultViewModelOutput {
    
}

protocol ResultViewModel: ResultViewModelInput, ResultViewModelOutput { }

class DefaultResultViewModel: ResultViewModel {
    
    // MARK: - OUTPUT

}

// MARK: - INPUT. View event methods
extension DefaultResultViewModel {
    func viewDidLoad() {
    }
}
