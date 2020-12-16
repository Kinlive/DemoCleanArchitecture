//
//  ResultViewController.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Action

class ResultViewController: UIViewController {

  private let bag = DisposeBag()
  var viewModel: ResultViewModel!

  class func create(with viewModel: ResultViewModel) -> ResultViewController {
    let vc = ResultViewController.instantiateViewController()
    vc.viewModel = viewModel
    //vc.loadViewIfNeeded()
    //vc.bind(to: viewModel)
    return vc
  }

  // MARK: - UIs
  lazy var photosCollectionView: UICollectionView = {
    var layout = UICollectionViewFlowLayout()

    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collection.register(PhotosResultCell.self, forCellWithReuseIdentifier: PhotosResultCell.storyboardIdentifier)
    collection.translatesAutoresizingMaskIntoConstraints = false
    collection.delegate = self
    //collection.dataSource = self

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
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("\n\n\(#function)\n\n")
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    makeUIsConstraints()
    makeUIs()
  }

    deinit {
        print("ResultViewController deinit")
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

    let favoriteSelected = PublishSubject<(Bool, IndexPath)>()

    let triggerWillAppear = rx.viewWillAppear
      //.take(1) // ?
      .map { _ in }
      .asDriver(onErrorJustReturn: ())

    let input = ResultInput(
      triggerFetch: triggerWillAppear,
      photoSelected: favoriteSelected
    )

    let dataSource = RxCollectionViewSectionedReloadDataSource<ResultCellSection>(configureCell: {
      dataSource, tableView, indexPath, viewModel -> UICollectionViewCell in
      let cell: PhotosResultCell = tableView.dequeueReusableCell(for: indexPath)

      cell.bindViewModel(
        viewModel,
        action: .init(),
        at: indexPath)

      // 不能每個 cell 共用一個 observable, 因此改以發送元素的方式代替點擊並傳遞 indexPath等資訊
      cell.favoriteButton.rx.tap
        .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
        .map { [unowned cell] in cell.favoriteButton.isSelected }
        .do(afterNext: { _ in
          cell.favoriteButton.isSelected.toggle()
        })
        .subscribe(onNext: { isSelected in
          print("On button selected : \(isSelected)")
          favoriteSelected.onNext((isSelected, indexPath))
        })
        .disposed(by: cell.bag)

      return cell
    })

    /* 只是監聽看看是否能監聽到 reload，可以！
     photosCollectionView.rx.methodInvoked(#selector(UICollectionView.reloadData))
       .subscribe(onNext: { _ in
         print("Collection reloaded when methodInvoked.")
       })
       .disposed(by: bag)

     photosCollectionView.rx.sentMessage(#selector(UICollectionView.reloadData))
       .subscribe(onNext: { _ in
         print("Collection reloaded when sentMessage.")
       })
       .disposed(by: bag)
     */

    photosCollectionView.rx.itemSelected.asObservable()
      .do(onNext: { indexPath in self.photosCollectionView.deselectItem(at: indexPath, animated: true) })
      .subscribe()
      .disposed(by: bag)

    // transform input to output
    let output = viewModel.transform(input: input)

    output.sectionOfCells.debug("Section Of cells")
      .asDriver(onErrorJustReturn: [])
      .drive(photosCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: bag)

    output.saved.debug("on saved")
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] indexPath in
        print("\n==== save \(indexPath) success ==========\n")
        self?.alert(title: "加入最愛", message: "加入第 \(indexPath) 個！", action: nil)
      }, onError: { error in
        print("\n==== save failed : \(error) ==========\n")
      }, onCompleted: {
        print("\n==== save complete ==========\n")
      })
      .disposed(by: bag)

    output.removed.debug("on remove")
      .materialize()
      .subscribe(onNext: { event in
        switch event {
        case .next(let never):
          print("\n === remove onNext: \(never) === \n")
        case .completed:
           print("\n==== remove successed ==========\n")
        case .error(let error):
          print("\n==== remove failed :\(error) ==========\n")
        }
      })
      .disposed(by: bag)
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
extension ResultViewController: UICollectionViewDelegateFlowLayout {

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
}
