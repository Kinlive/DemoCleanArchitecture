//
//  SearchViewController.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import UIKit
import Moya


class SearchViewController: UIViewController, StoryboardInstantiable {

  var viewModel: SearchViewModel!

  class func create(with viewModel: SearchViewModel) -> SearchViewController {
      let vc = SearchViewController.instantiateViewController()
      vc.viewModel = viewModel
      return vc
  }

  // MARK: - UIs

  let aTestLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.textColor = .red
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let fetchRemoteButton: UIButton = {
    let btn = UIButton(frame: .zero)
    btn.setTitle("抓取圖片", for: .normal)
    btn.setTitleColor(.black, for: .normal)
    btn.backgroundColor = .darkGray
    btn.addTarget(self, action: #selector(remoteTapped), for: .touchUpInside)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  let fetchLocalButton: UIButton = {
    let btn = UIButton(frame: .zero)
    btn.setTitle("讀取本地圖片", for: .normal)
    btn.setTitleColor(.red, for: .normal)
    btn.backgroundColor = .darkGray
    btn.addTarget(self, action: #selector(localTapped), for: .touchUpInside)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubviews()
    bindViewModel()
    viewModel.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    makeUIsConstraints()
    makeUIs()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  private func bindViewModel() {
    self.viewModel.onLocalPhotosCompletion = { photos in
      // refresh UIs
      print("\n>>>>>>>>>>>>>>> Local >>>>>>>>>>>>>>>>>>\n \(photos) \n")
    }

    self.viewModel.onRemotePhotosCompletion = { photos in
      // refresh UIs
      print("\n>>>>>>>>>>>>>>>> Remote >>>>>>>>>>>>>>>>>\n \(photos) \n")
    }

    self.viewModel.onSearchError = { error in
      // show error message.
      print("\n !!!!!!!!!!!!!!!!!!!!!!!!! ERROR !!!!!!!!!!!!!!!!!!!!!\n \(error)\n")
    }
    
  }

  private func addSubviews() {
    view.addSubview(aTestLabel)
    view.addSubview(fetchRemoteButton)
    view.addSubview(fetchLocalButton)
  }

  private func makeUIs() {

  }

  private func makeUIsConstraints() {
    aTestLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    aTestLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    fetchRemoteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    fetchRemoteButton.topAnchor.constraint(equalTo: aTestLabel.bottomAnchor, constant: 10).isActive = true
    fetchRemoteButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    fetchRemoteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

    fetchLocalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    fetchLocalButton.topAnchor.constraint(equalTo: fetchRemoteButton.bottomAnchor, constant: 10).isActive = true
    fetchLocalButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    fetchLocalButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
  }

  // MARK: - Actions viewModel.Input
  @objc private func remoteTapped() {
    // Sample use with service request
    let searchTexts = ["cat", "dog", "car", "bus", "coffee", "fruit"]

    for (i, text) in searchTexts.enumerated() {
      let query = PhotosQuery(searchText: text, perPage: 3, page: i + 1)

      viewModel.fetchRemote(query: query)

    }
  }

  @objc private func localTapped() {

    let searchTexts = ["cat", "dog", "car"]
    for (i, text) in searchTexts.enumerated() {
      let query = PhotosQuery(searchText: text, perPage: 3, page: i + 1)
      viewModel.fetchLocal(query: query)
    }

  }
}
