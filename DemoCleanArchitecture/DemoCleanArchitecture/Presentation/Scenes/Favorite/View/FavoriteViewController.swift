//
//  FavoriteViewController.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
  var viewModel: FavoriteViewModel!

  class func create(with viewModel: FavoriteViewModel) -> FavoriteViewController {
      let vc = FavoriteViewController.instantiateViewController()
      vc.viewModel = viewModel
      return vc
  }

  let testLabel: UILabel = {
    let label = UILabel()
    label.textColor = .brown
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    addSubviews()
    bind(to: viewModel)
    viewModel.viewDidLoad()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    makeUIsConstraints()
    makeUIs()
  }

  func bind(to viewModel: FavoriteViewModel) {
    testLabel.text = viewModel.title
  }

  // MARK: - Private mathods.
  private func addSubviews() {
    view.addSubview(testLabel)
  }

  private func makeUIs() {

  }

  private func makeUIsConstraints() {
    testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
}
