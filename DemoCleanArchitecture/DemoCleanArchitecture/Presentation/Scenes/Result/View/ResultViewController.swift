//
//  ResultViewController.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
  var viewModel: ResultViewModel!

  class func create(with viewModel: ResultViewModel) -> ResultViewController {
    let vc = ResultViewController.instantiateViewController()
    vc.viewModel = viewModel
    return vc
  }

  // MARK: - UIs
  lazy var photosCollectionView: UICollectionView = {
    var layout = UICollectionViewFlowLayout()

    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collection.register(PhotosResultCell.self, forCellWithReuseIdentifier: PhotosResultCell.storyboardIdentifier)
    collection.translatesAutoresizingMaskIntoConstraints = false
    collection.delegate = self
    collection.dataSource = self
    collection.backgroundColor = .lightGray

    return collection
  }()

  // MARK: - Properties
  private let constraints = Constraints()

  // MARK: - Life cycle
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

  // MARK: - Make UIs
  private func addSubviews() {
    view.addSubview(photosCollectionView)
  }
  private func makeUIs() {

  }

  private func makeUIsConstraints() {
    constraints.collection.top = photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
    constraints.collection.left = photosCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
    constraints.collection.right = photosCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
    constraints.collection.bottom = photosCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)

    constraints.activateAll()
  }

  private func bind(to viewModel: ResultViewModel) {
    
    self.viewModel.onPhotosPrepared = { [weak self] strings in
      print(strings)
      DispatchQueue.main.async {
        self?.photosCollectionView.reloadData()
      }
    }

    self.viewModel.onPhotoSaved = { [weak self] indexPath in
      DispatchQueue.main.async {
        self?.photosCollectionView.reloadItems(at: [indexPath])
      }
    }
  }
}

// MARK: - NSLayoutConstraints struct
extension ResultViewController {
  private struct Constraints: LayoutConstraints {
    let collection = NSLayoutConstraintSet()

    var all: [NSLayoutConstraintSet] { [ collection ] }
  }
}

// MARK: - UICollectionView dataSource & delegate
extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.photos?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: PhotosResultCell = collectionView.dequeueReusableCell(for: indexPath)

    if let photo = viewModel.photos?[indexPath.row] {

      cell.configure(
        input: .init(
          photo: photo,
          indexPath: indexPath,
          wasFavorite: viewModel.favoritePhotos?.contains(photo) ?? false),
        output: .init(
          onFavoriteSelected: onFavoriteSelect(input:),
          onFavoriteCanceled: onFavoriteCancel(input:))
      )
    }

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemHeight = collectionView.frame.height * 0.33
    let itemWidth = collectionView.frame.width
    return CGSize(width: itemWidth, height: itemHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

  }

  private func onFavoriteSelect(input: PhotosResultCell.Input) {
    viewModel.addFavorite(of: input.indexPath)
  }
  private func onFavoriteCancel(input: PhotosResultCell.Input) {
    viewModel.removeFavorite(of: input.indexPath)
  }
}
