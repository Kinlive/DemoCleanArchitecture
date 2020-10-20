//
//  SearchViewController.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import UIKit
import Moya


class SearchViewController: UIViewController {

  var viewModel: SearchViewModel!

  class func create(with viewModel: SearchViewModel) -> SearchViewController {
      let vc = SearchViewController.instantiateViewController()
      vc.viewModel = viewModel
      return vc
  }

  // MARK: - UIs

  let startFetchButton: UIButton = {
    let btn = UIButton(frame: .zero)
    btn.setTitle("抓取圖片", for: .normal)
    btn.setTitleColor(.black, for: .normal)
    btn.backgroundColor = .darkGray
    btn.addTarget(self, action: #selector(remoteTapped), for: .touchUpInside)
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
    btn.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
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
    accessoryView.insertCustomToTopStackView(view: doneButton, completion: nil)
    return accessoryView
  }()

  lazy var doneButton: UIButton = {
    let btn = UIButton()
    btn.setTitle("done", for: .normal)
    btn.setTitleColor(.red, for: .normal)
    btn.addTarget(self, action: #selector(onEdited(sender:)), for: .touchUpInside)
    return btn
  }()

  // Search Record.
  lazy var recordTableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(SearchRecordCell.self, forCellReuseIdentifier: SearchRecordCell.storyboardIdentifier)
    return tableView
  }()

  private let constraints: Constraints = Constraints()

  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubviews()
    bindViewModel()
    viewModel.viewDidLoad()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    makeUIsConstraints()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    makeUIs()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.viewWillAppear()
  }

  // Bind viewModel
  private func bindViewModel() {
    self.viewModel.onLocalPhotosCompletion = { photos in
      // refresh UIs
      print("\n>>>>>>>>>>>>>>> Local >>>>>>>>>>>>>>>>>>\n \\(photos) \n")
    }

    self.viewModel.onRemotePhotosCompletion = { photos in
      // refresh UIs
      print("\n>>>>>>>>>>>>>>>> Remote >>>>>>>>>>>>>>>>>\n \(photos) \n")
    }

    self.viewModel.onSearchError = { error in
      // show error message.
      print("\n !!!!!!!!!!!!!!!!!!!!!!!!! ERROR !!!!!!!!!!!!!!!!!!!!!\n \(error)\n")
    }

    viewModel.onRecordQuerysCompletion = { [weak self] in
      DispatchQueue.main.async {
        self?.recordTableView.reloadData()
      }
    }
    
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
  @objc private func remoteTapped() {
    resignSubviewsFirstResponder()

    let perPage = Int(perPageTextField.text ?? "0") ?? 0
    let page = Int(pageTextField.text ?? "0") ?? 0
    let photoQuery = PhotosQuery(
      searchText: searchTextField.text ?? "",
      perPage: perPage,
      page: page)

    viewModel.fetchRemote(query: photoQuery)

  }

  @objc private func clearTapped() {
    searchTextField.text = nil
    perPageTextField.text = nil
    pageTextField.text = nil

  }

  @objc private func onEdited(sender: UIButton) {
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

// MARK: - UITableView delegate & dataSource
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.recordQuerys?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: SearchRecordCell = tableView.dequeueReusableCell(for: indexPath)
    if let query = viewModel.recordQuerys?[indexPath.row] {
      cell.configure(
        with: .init(recordQuery: query, indexPath: indexPath),
        and: .init()
      )
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let selectedQuery = viewModel.recordQuerys?[indexPath.row] else { return }
    tableView.deselectRow(at: indexPath, animated: true)
    print(selectedQuery.searchText)
  }

}
