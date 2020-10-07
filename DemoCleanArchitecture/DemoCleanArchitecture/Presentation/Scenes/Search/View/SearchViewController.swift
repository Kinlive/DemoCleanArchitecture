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

  let aTestLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.textColor = .red
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    addSubviews()
    bind(to: viewModel)
    viewModel.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    makeUIsConstraints()
    makeUIs()
  }
  let storage = CoreDataPhotosStorage()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Sample use with service request
    let searchTexts = ["cat", "dog", "car", "bus", "coffee", "fruit"]

    let secondService = SearchService(provider: MoyaProvider<FlickrAPIType>(plugins: [NetworkLoggerPlugin()]))

    for (i, text) in searchTexts.enumerated() {
      let query = PhotosQuery(searchText: text, perPage: 3, page: 1)

      secondService.request(targetType: .searchPhotos(parameter: query)) { [weak self] returnValue in
        if let error = returnValue.error {
          print(error.localizedDescription)
          return
        }

        guard let domain = returnValue.domain else { print("Not get domain"); return }
        print("I got it: \n\(domain)\n")
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 1 + Double(i)) {

        self.storage.getResponse(for: .init(query: query)) { (result) in
          print("======================== get response from coredata================")
          print(result)
          print("\n")
        }
      }
    }

  }

  func bind(to viewModel: SearchViewModel) {

    aTestLabel.text = viewModel.testTitle
  }

  private func addSubviews() {
    view.addSubview(aTestLabel)
  }

  private func makeUIs() {

  }

  private func makeUIsConstraints() {
    aTestLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    aTestLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
}
