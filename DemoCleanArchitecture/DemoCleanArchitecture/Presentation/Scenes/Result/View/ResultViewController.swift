//
//  ResultViewController.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, StoryboardInstantiable {
    
    var viewModel: ResultViewModel!
    
    class func create(with viewModel: ResultViewModel) -> ResultViewController {
        let vc = ResultViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    func bind(to viewModel: ResultViewModel) {
      self.viewModel.onPhotosPrepared = { strings in
        print(strings)
      }
    }
}
