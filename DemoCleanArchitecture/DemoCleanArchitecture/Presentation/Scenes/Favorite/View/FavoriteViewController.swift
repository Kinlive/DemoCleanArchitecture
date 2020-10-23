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

  // MARK: - Subviews
  lazy var favoritesTableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(PhotoFavoriteCell.self, forCellReuseIdentifier: PhotoFavoriteCell.storyboardIdentifier)
    table.separatorStyle = .none
    table.delegate = self
    table.dataSource = self
    table.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)

    return table
  }()

  // MARK: - Properties
  private let constraints: Constraints = Constraints()

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

  func bind(to viewModel: FavoriteViewModel) {

  }

  // MARK: - Private mathods.
  private func addSubviews() {
    view.addSubview(favoritesTableView)

  }

  private func makeUIs() {

  }

  private func makeUIsConstraints() {
    constraints.table.top = favoritesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
    constraints.table.left = favoritesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
    constraints.table.right = favoritesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
    constraints.table.bottom = favoritesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)

    constraints.activateAll()
  }
}

// MARK: - Constaints
extension FavoriteViewController {
  private struct Constraints: LayoutConstraints {
    let table = NSLayoutConstraintSet()

    var all: [NSLayoutConstraintSet] { [table] }
  }
}

// MARK: - UITableView delegate & dataSource
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: PhotoFavoriteCell = tableView.dequeueReusableCell(for: indexPath)
    cell.configure(input: inputForCell(at: indexPath),
                   output: outputForCell(at: indexPath))
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return FavoriteHeaderView(
      input: .init(title: "test", section: section),
      output: .init(onTappedHeader: tappedHeader)
    )
  }

  private func tappedHeader(_ isExpanding: Bool, _ section: Int) {
    print(#function)

    let indexPaths = Array(0...2).map { IndexPath(item: $0, section: section) }

    /*
    favoritesTableView.performBatchUpdates({
      isExpanding
        ? favoritesTableView.insertRows(at: indexPaths, with: .left)
        : favoritesTableView.deleteRows(at: indexPaths, with: .fade)

    }) { (end) in

    }
     */
  }

  private func inputForCell(at indexPath: IndexPath) -> PhotoFavoriteCell.Input {
    return .init(
      indexPath: indexPath,
      photo: .init(
        id: UUID().uuidString,
        owner: "Kin",
        secret: "Hi",
        server: "Bye",
        farm: 0,
        title: "Demo cell",
        ispublic: 0,
        isfriend: 0,
        isfamily: 0
      )
    )
  }

  private func outputForCell(at indexPath: IndexPath) -> PhotoFavoriteCell.Output {
    return .init()
  }

}
