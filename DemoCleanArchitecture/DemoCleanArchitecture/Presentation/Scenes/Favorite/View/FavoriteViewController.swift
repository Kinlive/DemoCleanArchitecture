//
//  FavoriteViewController.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

class FavoriteViewController: UIViewController {

  private let bag = DisposeBag()
    
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
    table.register(FavoriteHeaderView.self, forHeaderFooterViewReuseIdentifier: FavoriteHeaderView.storyboardIdentifier)
    table.separatorStyle = .none
    //table.delegate = self
    //table.dataSource = self
    table.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)

    return table
  }()

  // MARK: - Properties
  private let constraints: Constraints = Constraints()
  private var cacheHeaders: [Int: FavoriteHeaderView] = [:]

  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubviews()
    bind(to: viewModel)
    //viewModel.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //viewModel.viewWillAppear()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    makeUIsConstraints()
    makeUIs()
  }

  func bind(to viewModel: FavoriteViewModel) {

    let deleteFavorite = PublishSubject<IndexPath>()
    let triggerReload = PublishSubject<Bool>()

    rx.viewWillAppear
      .bind(to: triggerReload)
      .disposed(by: bag)

    let input = FavoriteInput(
      viewWillAppear: triggerReload,
      deleteFavorite: deleteFavorite)

    let dataSources = RxTableViewSectionedAnimatedDataSource<FavoriteSection>(
      configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
        let cell: PhotoFavoriteCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(
          input: .init(indexPath: indexPath, photo: item),
          output: .init()
        )
        return cell
      },
      // 與 tableViewDelegate.tableView(_:viewForHeaderInSection:) -> UIView? 可共用，此處設置的title為 UITableViewHeaderFooterView.textLabel。若兩邊皆有設置title，最後會以此處為準
      titleForHeaderInSection: { (dataSource, section) -> String? in
        return dataSource.sectionModels[section].model
      },
      // [Notice]: - 要搭配 tableView.rx.itemDeleted/item other actions 一起使用
      canEditRowAtIndexPath: { dataSource, indexPath -> Bool in
        return true
      })

    dataSources.decideViewTransition = { ds, tv, changest in
        print(changest)
        return .animated
    }

    favoritesTableView.rx
      .setDelegate(self)
      .disposed(by: bag)

    favoritesTableView.rx.itemDeleted
      .bind(to: deleteFavorite)
      .disposed(by: bag)

    let output = viewModel.transform(input: input)

    output.sectionModels
      .asDriver(onErrorJustReturn: [])
      .drive(favoritesTableView.rx.items(dataSource: dataSources))
      .disposed(by: bag)

    output.removeFavorite
      .map { _ in true }
      .bind(to: triggerReload)
      .disposed(by: bag)

//    favoritesTableView.rx.headerEvent
//    .subscribe(onNext: { any in print(any) })
//    .disposed(by: bag)
    
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

  private func expandTable(isExpanding: Bool, indexPaths: [IndexPath]) {

    favoritesTableView.performBatchUpdates({
      isExpanding
        ? favoritesTableView.insertRows(at: indexPaths, with: .left)
        : favoritesTableView.deleteRows(at: indexPaths, with: .fade)
    }) { end in }

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
extension FavoriteViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let view = cacheHeaders[section] {
        return view
    }

    let header: FavoriteHeaderView = tableView.dequeueReusableHeaderFooterView()
    header.configure(
        input: .init(title: "Alllll", section: section, isExpand: viewModel.expandsIndex[section] ?? true),
      output: .init(onTappedHeader: { [weak self] (isExpanding, index) in
        print("tapped on \(index) now isExpanding: \(isExpanding)")
        self?.viewModel.sectionHeaderTapped.onNext((isExpanding, index))
      }))
    cacheHeaders[section] = header
    return header
  }

}
