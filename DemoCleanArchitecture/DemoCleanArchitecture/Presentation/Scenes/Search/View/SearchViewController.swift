//
//  SearchViewController.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import RxDataSources


class SearchViewController: UIViewController {

  var viewModel: SearchViewModel!

  class func create(with viewModel: SearchViewModel) -> SearchViewController {
      let vc = SearchViewController.instantiateViewController()
      vc.viewModel = viewModel
      vc.bindViewModel()
      return vc
  }

  // MARK: - UIs

  let startFetchButton: UIButton = {
    let btn = UIButton(frame: .zero)
    btn.setTitle("抓取圖片", for: .normal)
    btn.setTitleColor(.black, for: .normal)
    btn.backgroundColor = .darkGray
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  let clearButton: UIButton = {
    let btn = UIButton(frame: .zero)
    btn.setTitle("清除搜尋", for: .normal)
    btn.setTitleColor(.red, for: .normal)
    btn.backgroundColor = .darkGray
    btn.layer.cornerRadius = 5
    btn.layer.masksToBounds = true
    btn.layer.borderColor = UIColor.red.cgColor
    btn.layer.borderWidth = 1.5
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  lazy var searchTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "搜尋名稱..."
    tf.borderStyle = .roundedRect
    tf.translatesAutoresizingMaskIntoConstraints = false
    tf.delegate = self
    return tf
  }()

  lazy var pageTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "第幾頁"
    tf.backgroundColor = .white
    tf.borderStyle = .bezel
    tf.keyboardType = .numberPad
    tf.delegate = self
    tf.translatesAutoresizingMaskIntoConstraints = false

    tf.inputAccessoryView = baseAccessoryView
    return tf
  }()

  lazy var perPageTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "每頁筆數"
    tf.backgroundColor = .white
    tf.borderStyle = .line
    tf.keyboardType = .numberPad
    tf.translatesAutoresizingMaskIntoConstraints = false
    tf.delegate = self

    tf.inputAccessoryView = baseAccessoryView

    return tf
  }()

  let inputBaseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  // Keyboard support views
  lazy var baseAccessoryView: BaseAccessoryView = {
    let accessoryView = BaseAccessoryView()
    accessoryView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
    accessoryView.insertCustomToTopStackView(view: doneButton, completion: nil)
    return accessoryView
  }()

  lazy var doneButton: UIButton = {
    let btn = UIButton()
    btn.setTitle("done", for: .normal)
    btn.setTitleColor(.blue, for: .normal)
    return btn
  }()

  // Search Record.
  lazy var recordTableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(SearchRecordCell.self, forCellReuseIdentifier: SearchRecordCell.storyboardIdentifier)
    return tableView
  }()

  private let constraints: Constraints = Constraints()
  private let bag = DisposeBag()

  // tableView datasource
  private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, PhotosQuery>>(
    configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in
      let cell: SearchRecordCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(with: .init(recordQuery: item, indexPath: indexPath), and: .init())
      return cell
    },
    titleForHeaderInSection: { sectionModels, section in
      return sectionModels[section].model
    })

  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubviews()
    //bindViewModel()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    makeUIsConstraints()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    makeUIs()
  }

  // Bind viewModel
  private func bindViewModel() {

    let trigger = rx.viewWillAppear.asDriver().map { _ in }

    let input = SearchViewModelInput(triggerReload: trigger, clear: clearButton.rx.tap.asDriver())

    recordTableView.rx.itemSelected
      .do(onNext: { [weak self] indexPath in self?.recordTableView.deselectRow(at: indexPath, animated: false) })
      .subscribe(input.selectedRecord)
      .disposed(by: bag)

    searchTextField.rx.text.orEmpty
      .bind(to: input.searchText)
      .disposed(by: bag)

    perPageTextField.rx.text.orEmpty
      .bind(to: input.perPage)
      .disposed(by: bag)

    pageTextField.rx.text.orEmpty
      .bind(to: input.page)
      .disposed(by: bag)

    startFetchButton.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .do(onNext: { [weak self] _ in self?.resignSubviewsFirstResponder() })
      .bind(to: input.onTappedSearchButton)
      .disposed(by: bag)

    clearButton.rx.controlEvent(.touchUpInside)
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        self?.searchTextField.text = nil
        self?.perPageTextField.text = nil
        self?.pageTextField.text = nil
      })
      .disposed(by: bag)

    doneButton.rx.controlEvent(.touchUpInside)
      .subscribe(onNext: { [weak self] in self?.onEdited()})
      .disposed(by: bag)

    let output = viewModel.convert(input: input)

    output.reload
      .drive(recordTableView.rx.items(dataSource: dataSource))
      .disposed(by: bag)
  }

  // MARK: - UIs setup
  private func addSubviews() {
    view.addSubview(startFetchButton)
    view.addSubview(clearButton)
    view.addSubview(recordTableView)
    view.addSubview(inputBaseView)

    inputBaseView.addSubview(searchTextField)
    inputBaseView.addSubview(pageTextField)
    inputBaseView.addSubview(perPageTextField)

  }

  private func makeUIs() {
    // make inputBaseView's shadow layer
    /* inputBaseView.layer.frame.size = inputBaseView.frame.size
    inputBaseView.layer.shadowColor = UIColor.black.cgColor
    inputBaseView.layer.shadowRadius = 10
    inputBaseView.layer.shadowOpacity = 1
    inputBaseView.layer.shouldRasterize = true
    inputBaseView.layer.rasterizationScale = UIScreen.main.scale
    inputBaseView.layer.shadowOffset = CGSize(width: -5, height: -5)
    inputBaseView.layer.shadowPath = UIBezierPath(rect: inputBaseView.bounds).cgPath
    inputBaseView.layer.masksToBounds = true
     */

    recordTableView.layer.borderWidth = 1.5
    recordTableView.layer.borderColor = UIColor.orange.cgColor
    recordTableView.layer.cornerRadius = 10
    recordTableView.layer.masksToBounds = true
    recordTableView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
  }

  private func makeUIsConstraints() {
    // inputBaseView
    constraints.inputBase.width = inputBaseView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
    constraints.inputBase.height = inputBaseView.heightAnchor.constraint(equalToConstant: 100)
    constraints.inputBase.top = inputBaseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    constraints.inputBase.centerX = inputBaseView.centerXAnchor.constraint(equalTo: view.centerXAnchor)

    let baseWidth = constraints.inputBase.width?.constant ?? view.frame.width * 0.9
    let baseHeight = constraints.inputBase.height?.constant ?? 100

    let textFieldHeight = baseHeight * 0.45
    let verticalPadding: CGFloat = baseHeight * 0.5 - textFieldHeight
    let horizontalPadding: CGFloat = 10

    // searchTextField
    constraints.searchText.width = searchTextField.widthAnchor.constraint(equalToConstant: baseWidth * 0.95)
    constraints.searchText.height = searchTextField.heightAnchor.constraint(equalToConstant: textFieldHeight)
    constraints.searchText.top = searchTextField.topAnchor.constraint(equalTo: inputBaseView.topAnchor, constant: 10)
    constraints.searchText.centerX = searchTextField.centerXAnchor.constraint(equalTo: inputBaseView.centerXAnchor)

    // perPageTextField
    constraints.perPage.left = perPageTextField.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor)
    constraints.perPage.top = perPageTextField.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: verticalPadding)
    constraints.perPage.right = perPageTextField.trailingAnchor.constraint(equalTo: pageTextField.leadingAnchor, constant: -horizontalPadding)
    constraints.perPage.width = perPageTextField.widthAnchor.constraint(equalTo: pageTextField.widthAnchor, multiplier: 1)
    constraints.perPage.bottom = perPageTextField.bottomAnchor.constraint(greaterThanOrEqualTo: inputBaseView.bottomAnchor, constant: -10)

    // pageTextField
    constraints.page.top = pageTextField.topAnchor.constraint(equalTo: perPageTextField.topAnchor)
    constraints.page.right = pageTextField.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor)
    constraints.page.bottom = pageTextField.bottomAnchor.constraint(equalTo: perPageTextField.bottomAnchor)

    // start fetch button
    constraints.startFetch.top = startFetchButton.topAnchor.constraint(equalTo: inputBaseView.bottomAnchor, constant: 30)
    constraints.startFetch.width = startFetchButton.widthAnchor.constraint(equalToConstant: 120)
    constraints.startFetch.height = startFetchButton.heightAnchor.constraint(equalToConstant: 50)
    constraints.startFetch.left = startFetchButton.leadingAnchor.constraint(equalTo: inputBaseView.leadingAnchor)

    // clear button
    constraints.clear.top = clearButton.topAnchor.constraint(equalTo: startFetchButton.topAnchor)
    constraints.clear.right = clearButton.trailingAnchor.constraint(equalTo: inputBaseView.trailingAnchor)
    constraints.clear.width = clearButton.widthAnchor.constraint(equalToConstant: 100)
    constraints.clear.height = clearButton.heightAnchor.constraint(equalTo: startFetchButton.heightAnchor)

    // record tableView
    constraints.recordTable.top = recordTableView.topAnchor.constraint(equalTo: startFetchButton.bottomAnchor, constant: 20)
    constraints.recordTable.left = recordTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
    constraints.recordTable.right = recordTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    constraints.recordTable.bottom = recordTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)

    constraints.activateAll()
  }

  // MARK: - Actions viewModel.Input

//  @objc private func remoteTapped() {
//    resignSubviewsFirstResponder()
//    guard let searchText = searchTextField.text, !searchText.isEmpty else { return}
//    let perPage = Int(perPageTextField.text ?? "0") ?? 0
//    let page = Int(pageTextField.text ?? "0") ?? 0
//    let photoQuery = PhotosQuery(
//      searchText: searchText,
//      perPage: perPage,
//      page: page)
//
//    viewModel.fetchRemote(query: photoQuery)
//
//  }

//  @objc private func clearTapped() {
//    searchTextField.text = nil
//    perPageTextField.text = nil
//    pageTextField.text = nil
//
//  }

  @objc private func onEdited() {
    switch true {
    case perPageTextField.isFirstResponder:
      pageTextField.becomeFirstResponder()

    case pageTextField.isFirstResponder:
      pageTextField.resignFirstResponder()

    default:
      break
    }
  }

  private func resignSubviewsFirstResponder() {
    switch true {
    case perPageTextField.isFirstResponder:
      perPageTextField.resignFirstResponder()

    case pageTextField.isFirstResponder:
      pageTextField.resignFirstResponder()

    default:
      break
    }
  }
}

// MARK: - NSLayoutConstraintSet struct
extension SearchViewController {
  private struct Constraints: LayoutConstraints {
    let searchText: NSLayoutConstraintSet = NSLayoutConstraintSet()
    let page: NSLayoutConstraintSet = NSLayoutConstraintSet()
    let perPage: NSLayoutConstraintSet = NSLayoutConstraintSet()
    let inputBase: NSLayoutConstraintSet = NSLayoutConstraintSet()
    let startFetch: NSLayoutConstraintSet = NSLayoutConstraintSet()
    let clear: NSLayoutConstraintSet = NSLayoutConstraintSet()
    let recordTable: NSLayoutConstraintSet = NSLayoutConstraintSet()

    var all: [NSLayoutConstraintSet] {
      [searchText, page, perPage, inputBase, startFetch, clear, recordTable]
    }

  }
}

// MARK: - UITextField delegate
extension SearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch true {
    case textField === searchTextField:
      perPageTextField.becomeFirstResponder()

    default: break
    }

    print(textField.text ?? "")
    return true
  }

}
